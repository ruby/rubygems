# frozen_string_literal: true

require "ripper"

module Bundler
  # Reads and rewrites the version requirements of `gem "name", ...`
  # declarations in Gemfile source code.
  #
  # The source is tokenized with Ripper, so strings, comments, percent
  # literals, regexps and heredocs are recognized the way Ruby sees them. Only
  # the requirement string literals that directly follow the gem name are
  # touched; options, comments and the layout of the declaration are kept.
  class GemfileRequirementRewriter
    Token = Struct.new(:event, :text, :start) do
      def finish
        start + text.bytesize
      end
    end

    # A string literal argument, with the byte offsets it spans.
    Literal = Struct.new(:value, :start, :finish, :last_index)

    # A `gem` call whose name is a plain string literal. `requirements` are
    # the requirement literals that directly follow the name, each preceded
    # by the comma in `commas_before`, and `comma_after` is the comma
    # following the last of them when more arguments follow.
    Declaration = Struct.new(:name_literal, :requirements, :commas_before, :comma_after) do
      def name
        name_literal.value
      end
    end

    # Tokens with no meaning to the parser.
    INSIGNIFICANT = [:on_sp, :on_ignored_sp, :on_ignored_nl, :on_comment, :on_embdoc_beg, :on_embdoc, :on_embdoc_end].freeze

    # Tokens that make a following `gem` something other than a call to the
    # Gemfile DSL method: a call on a receiver (`x.gem`, `x&.gem`, `X::gem`),
    # a symbol (`:gem`) or a method definition (`def gem`).
    NOT_A_DSL_CALL = [[:on_period, "."], [:on_op, "&."], [:on_op, "::"], [:on_symbeg, ":"], [:on_kw, "def"], [:on_kw, "alias"]].freeze

    # Tokens opening an array, which can also hold the requirements.
    ARRAY_OPENINGS = [:on_lbracket, :on_qwords_beg, :on_words_beg].freeze

    def initialize(source)
      @source = source
      @bytes = source.b
      @tokens = tokenize(source)
    end

    # @return [Boolean] whether the source declares the gem.
    def declares?(name)
      declarations.any? {|declaration| declaration.name == name }
    end

    # @return [Array<String>, nil] the requirements of the first declaration
    #   of the gem, as written (`["~> 1.0"]`, `["1.0"]`, or `[]` when it has
    #   none), or nil when the source does not declare the gem.
    def requirements_for(name)
      declaration = declarations.find {|d| d.name == name }
      declaration&.requirements&.map(&:value)
    end

    # Replaces the requirements of every declaration of the given gems.
    # Gems the source does not declare are ignored.
    # @param requirements [Hash{String => String, Array<String>}] gem name to
    #   new requirement(s).
    # @return [String] the rewritten source.
    def rewrite(requirements)
      edits = declarations.flat_map do |declaration|
        next [] unless requirements.key?(declaration.name)

        requirement_edits(declaration, Array(requirements[declaration.name]))
      end

      apply(edits)
    end

    private

    def tokenize(source)
      line_starts = [0]
      source.each_line {|line| line_starts << line_starts.last + line.bytesize }

      Ripper.lex(source).map do |(line, column), event, text|
        Token.new(event, text, line_starts[line - 1] + column)
      end
    end

    def declarations
      @declarations ||= @tokens.each_index.filter_map {|index| declaration_at(index) }
    end

    def declaration_at(index)
      token = @tokens[index]
      return unless token.event == :on_ident && token.text == "gem" && dsl_call?(index)

      cursor = significant_index(index + 1)
      cursor = significant_index(cursor + 1) if cursor && @tokens[cursor].event == :on_lparen
      name = string_literal_at(cursor)
      return unless name

      requirements = []
      commas = []
      cursor = significant_index(name.last_index + 1)
      while cursor && @tokens[cursor].event == :on_comma
        literal = string_literal_at(significant_index(cursor + 1))
        break unless literal && requirement?(literal.value)

        commas << @tokens[cursor]
        requirements << literal
        cursor = significant_index(literal.last_index + 1)
      end
      comma_after = @tokens[cursor] if cursor && @tokens[cursor].event == :on_comma
      # Requirements given as an array cannot be rewritten in place.
      following = comma_after && significant_index(cursor + 1)
      return if following && ARRAY_OPENINGS.include?(@tokens[following].event)

      Declaration.new(name, requirements, commas, comma_after)
    end

    def dsl_call?(index)
      previous = @tokens.first(index).reverse_each.find {|token| !INSIGNIFICANT.include?(token.event) }
      previous.nil? || !NOT_A_DSL_CALL.include?([previous.event, previous.text])
    end

    # @return [Integer, nil] index of the first significant token at or after
    #   `index`.
    def significant_index(index)
      index += 1 while index < @tokens.size && INSIGNIFICANT.include?(@tokens[index].event)
      index if index < @tokens.size
    end

    # @return [Literal, nil] the plain (not interpolated) string literal
    #   starting at `index`.
    def string_literal_at(index)
      return unless index && @tokens[index].event == :on_tstring_beg

      closing_index = index + 1
      closing_index += 1 if @tokens[closing_index]&.event == :on_tstring_content
      closing = @tokens[closing_index]
      return unless closing&.event == :on_tstring_end

      value = @tokens[(index + 1)...closing_index].map(&:text).join
      Literal.new(value, @tokens[index].start, closing.finish, closing_index)
    end

    def requirement?(value)
      Gem::Requirement::PATTERN.match?(value)
    end

    # @return [Array<Array(Integer, Integer, String)>] byte ranges to replace
    #   and their replacements.
    def requirement_edits(declaration, requirements)
      old = declaration.requirements
      edits = old.zip(requirements).filter_map do |literal, requirement|
        [literal.start, literal.finish, requirement.dump] if requirement
      end

      insertion = (old.last || declaration.name_literal).finish
      edits << [insertion, insertion, requirements.drop(old.size).map {|requirement| ", #{requirement.dump}" }.join]

      old.drop(requirements.size).each_with_index do |literal, offset|
        if declaration.comma_after
          following_comma = declaration.commas_before[requirements.size + offset + 1] || declaration.comma_after
          edits << deletion_through(literal, following_comma)
        else
          comma = declaration.commas_before[requirements.size + offset]
          edits << [comma.start, comma.finish, ""]
          edits << deletion_of(literal)
        end
      end

      edits
    end

    # Deletes a literal that is the last argument, together with the blanks
    # before it. When it is alone on its line, the line goes too.
    def deletion_of(literal)
      line_start = line_start_of(literal.start)
      if blank?(line_start, literal.start)
        newline = @bytes.byteslice(0, line_start).end_with?("\r\n") ? 2 : 1
        [line_start - newline, literal.finish, ""]
      else
        [skip_blanks_backwards(literal.start), literal.finish, ""]
      end
    end

    # Deletes a literal followed by more arguments, together with the comma
    # after it. When nothing else is on its line, the line goes too.
    def deletion_through(literal, comma)
      finish = skip_blanks_forwards(comma.finish)
      line_start = line_start_of(literal.start)
      if blank?(line_start, literal.start) && @bytes.byteslice(finish, 2).match?(/\A\r?\n/)
        [line_start, finish + (@bytes.byteslice(finish) == "\r" ? 2 : 1), ""]
      else
        [literal.start, finish, ""]
      end
    end

    def line_start_of(offset)
      newline = @bytes.byteslice(0, offset).rindex("\n")
      newline ? newline + 1 : 0
    end

    def blank?(start, finish)
      @bytes.byteslice(start, finish - start).strip.empty?
    end

    def skip_blanks_backwards(offset)
      offset - @bytes.byteslice(0, offset)[/[ \t]*\z/].bytesize
    end

    def skip_blanks_forwards(offset)
      offset + @bytes.byteslice(offset..)[/\A[ \t]*/].bytesize
    end

    def apply(edits)
      result = @bytes.dup
      edits.sort_by(&:first).reverse_each do |start, finish, replacement|
        result[start...finish] = replacement.b
      end
      result.force_encoding(@source.encoding)
    end
  end
end
