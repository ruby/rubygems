# frozen_string_literal: true

module Bundler
  class Injector
    INJECTED_GEMS = "injected gems"

    def self.inject(new_deps, options = {})
      injector = new(new_deps, options)
      injector.inject(Bundler.default_gemfile, Bundler.default_lockfile)
    end

    def self.remove(gems, options = {})
      injector = new(gems, options)
      injector.remove(Bundler.default_gemfile, Bundler.default_lockfile)
    end

    # Rewrites the version requirements of gems already declared in the
    # Gemfile, preserving options (groups, source, require, ...) and comments.
    # @param requirements [Hash{String => String, Array<String>}] gem name to new requirement(s)
    #   (e.g. `{ "rails" => ">= 8.0.0" }` or `{ "rails" => ["> 5.0.0", "< 5.1.1"] }`)
    # @return [Array<String>] names of gems whose Gemfile entries were rewritten
    def self.update_requirements(requirements)
      new([]).update_requirements(requirements)
    end

    def initialize(deps, options = {})
      @deps = deps
      @options = options
    end

    # @param [Pathname] gemfile_path The Gemfile in which to inject the new dependency.
    # @param [Pathname] lockfile_path The lockfile in which to inject the new dependency.
    # @return [Array]
    def inject(gemfile_path, lockfile_path)
      Bundler.definition.ensure_equivalent_gemfile_and_lockfile(true)

      # temporarily unfreeze
      Bundler.settings.temporary(deployment: false, frozen: false) do
        # evaluate the Gemfile we have now
        builder = Dsl.new
        builder.eval_gemfile(gemfile_path)

        # don't inject any gems that are already in the Gemfile
        @deps -= builder.dependencies

        # add new deps to the end of the in-memory Gemfile
        # Set conservative versioning to false because
        # we want to let the resolver resolve the version first
        builder.eval_gemfile(INJECTED_GEMS, build_gem_lines(false)) if @deps.any?

        # resolve to see if the new deps broke anything
        @definition = builder.to_definition(lockfile_path, {})
        @definition.remotely!

        # since nothing broke, we can add those gems to the gemfile
        append_to(gemfile_path, build_gem_lines(@options[:conservative_versioning])) if @deps.any?

        # since we resolved successfully, write out the lockfile
        @definition.lock

        # invalidate the cached Bundler.definition
        Bundler.reset_paths!

        # return an array of the deps that we added
        @deps
      end
    end

    # @param [Pathname] gemfile_path The Gemfile from which to remove dependencies.
    # @param [Pathname] lockfile_path The lockfile from which to remove dependencies.
    # @return [Array]
    def remove(gemfile_path, lockfile_path)
      # remove gems from each gemfiles we have
      Bundler.definition.gemfiles.each do |path|
        deps = remove_deps(path)

        show_warning("No gems were removed from the gemfile.") if deps.empty?

        deps.each {|dep| Bundler.ui.confirm "#{SharedHelpers.pretty_dependency(dep)} was removed." }
      end

      # Invalidate the cached Bundler.definition.
      # This prevents e.g. `bundle remove ...` from using outdated information.
      Bundler.reset_paths!
    end

    # @param [Hash{String => String, Array<String>}] requirements Gem name to new requirement(s).
    # @return [Array<String>] Names of gems whose Gemfile entries were rewritten.
    def update_requirements(requirements)
      Bundler.definition.ensure_equivalent_gemfile_and_lockfile(true)

      # temporarily unfreeze
      Bundler.settings.temporary(deployment: false, frozen: false) do
        updated = []

        Bundler.definition.gemfiles.each do |path|
          next unless File.file?(path)

          names = requirements.keys.select {|name| gemfile_declares?(path, name) }
          next if names.empty?

          updated |= rewrite_gemfile_requirements(path, requirements.slice(*names))
        end

        # invalidate the cached Bundler.definition, since the Gemfile changed
        Bundler.reset_paths!

        updated
      end
    end

    # Reads back the operators declared for a gem in a Gemfile, straight
    # from the source text. This distinguishes `gem "foo", "1.0"` (bare,
    # reported as nil) from `gem "foo", "= 1.0"` (explicit), which look
    # identical once parsed into a Gem::Requirement.
    # @return [Array<String, nil>, nil] explicit operators of the leading
    #   version arguments (nil element means bare), empty when no version is
    #   declared, nil when the gem is not declared in the file.
    def self.declared_operators(gemfile_path, name)
      new([], {}).declared_operators(gemfile_path, name)
    end

    def declared_operators(gemfile_path, name)
      declaration = find_gem_declaration(gemfile_path, name)
      return if declaration.nil?

      code, = split_trailing_comment(declaration.chomp)
      match_data = code.match(/\A(\s*gem\s*)(?:\(\s*)?(['"])(.+?)\2/)
      return if match_data.nil? || match_data[3] != name

      paren = code.match?(/\A\s*gem\s*\(/)
      rest = code[match_data[0].length..] || ""
      rest = rest.sub(/\A\s*,\s*/, "")
      rest = rest.sub(/\s*\)\s*\z/, "") if paren

      args = split_top_level_commas(rest).map(&:strip).reject(&:empty?)
      args.take_while {|arg| version_argument?(arg) }.map do |arg|
        inner = arg.match(/\A(['"])(.*)\1\z/m)[2]
        inner[/\A(>=|>|<=|<|~>|=|!=)/, 1]
      end
    end

    private

    def conservative_version(spec)
      version = spec.version
      return ">= 0" if version.nil?
      seg_end_index = version >= Gem::Version.new("1.0") ? 1 : 2

      prerelease_suffix = version.to_s.delete_prefix(version.release.to_s) if version.prerelease?
      "#{version_prefix}#{version.segments[0..seg_end_index].join(".")}#{prerelease_suffix}"
    end

    def version_prefix
      if @options[:strict]
        "= "
      elsif @options[:pessimistic]
        "~> "
      else
        ">= "
      end
    end

    def build_gem_lines(conservative_versioning)
      @deps.map do |d|
        name = d.name.dump

        requirement = if conservative_versioning
          ", \"#{conservative_version(@definition.specs[d.name][0])}\""
        else
          ", #{d.requirement.as_list.map(&:dump).join(", ")}"
        end

        if d.groups != Array(:default)
          group = d.groups.size == 1 ? ", group: #{d.groups.first.inspect}" : ", groups: #{d.groups.inspect}"
        end

        source = ", source: \"#{d.source}\"" unless d.source.nil?
        path = ", path: \"#{d.path}\"" unless d.path.nil?
        git = ", git: \"#{d.git}\"" unless d.git.nil?
        github = ", github: \"#{d.github}\"" unless d.github.nil?
        branch = ", branch: \"#{d.branch}\"" unless d.branch.nil?
        ref = ", ref: \"#{d.ref}\"" unless d.ref.nil?
        glob = ", glob: \"#{d.glob}\"" unless d.glob.nil?
        require_path = ", require: #{convert_autorequire(d.autorequire)}" unless d.autorequire.nil?

        %(gem #{name}#{requirement}#{group}#{source}#{path}#{git}#{github}#{branch}#{ref}#{glob}#{require_path})
      end.join("\n")
    end

    def append_to(gemfile_path, new_gem_lines)
      gemfile_path.open("a") do |f|
        f.puts
        f.puts new_gem_lines
      end
    end

    # evaluates a gemfile to remove the specified gem
    # from it.
    def remove_deps(gemfile_path)
      initial_gemfile = File.readlines(gemfile_path)

      Bundler.ui.info "Removing gems from #{gemfile_path}"

      # evaluate the Gemfile we have
      builder = Dsl.new
      builder.eval_gemfile(gemfile_path)

      removed_deps = remove_gems_from_dependencies(builder, @deps, gemfile_path)

      # abort the operation if no gems were removed
      # no need to operate on gemfile further
      return [] if removed_deps.empty?

      cleaned_gemfile = remove_gems_from_gemfile(@deps, gemfile_path)

      SharedHelpers.write_to_gemfile(gemfile_path, cleaned_gemfile)

      # check for errors
      # including extra gems being removed
      # or some gems not being removed
      # and return the actual removed deps
      cross_check_for_errors(gemfile_path, builder.dependencies, removed_deps, initial_gemfile)
    end

    # @param [Dsl]      builder Dsl object of current Gemfile.
    # @param [Array]    gems Array of names of gems to be removed.
    # @param [Pathname] gemfile_path Path of the Gemfile.
    # @return [Array]   Array of removed dependencies.
    def remove_gems_from_dependencies(builder, gems, gemfile_path)
      removed_deps = []

      gems.each do |gem_name|
        deleted_dep = builder.dependencies.find {|d| d.name == gem_name }

        if deleted_dep.nil?
          raise GemfileError, "`#{gem_name}` is not specified in #{gemfile_path} so it could not be removed."
        end

        builder.dependencies.delete(deleted_dep)

        removed_deps << deleted_dep
      end

      removed_deps
    end

    # @param [Array] gems            Array of names of gems to be removed.
    # @param [Pathname] gemfile_path The Gemfile from which to remove dependencies.
    def remove_gems_from_gemfile(gems, gemfile_path)
      patterns = /gem\s+(['"])#{Regexp.union(gems)}\1|gem\s*\((['"])#{Regexp.union(gems)}\2.*\)/
      new_gemfile = []
      multiline_removal = false
      File.readlines(gemfile_path).each do |line|
        match_data = line.match(patterns)
        if match_data && is_not_within_comment?(line, match_data)
          multiline_removal = line.rstrip.end_with?(",")
          # skip lines which match the regex
          next
        end

        # skip followup lines until line does not end with ','
        new_gemfile << line unless multiline_removal
        multiline_removal = line.rstrip.end_with?(",") if multiline_removal
      end

      # remove line \n and append them with other strings
      new_gemfile.each_with_index do |_line, index|
        if new_gemfile[index + 1] == "\n"
          new_gemfile[index] += new_gemfile[index + 1]
          new_gemfile.delete_at(index + 1)
        end
      end

      %w[group source env install_if].each {|block| remove_nested_blocks(new_gemfile, block) }

      new_gemfile.join.chomp
    end

    # @param [String] line          Individual line of gemfile content.
    # @param [MatchData] match_data Data about Regex match.
    def is_not_within_comment?(line, match_data)
      match_start_index = match_data.offset(0).first
      !line[0..match_start_index].include?("#")
    end

    # @param [Array] gemfile       Array of gemfile contents.
    # @param [String] block_name   Name of block name to look for.
    def remove_nested_blocks(gemfile, block_name)
      nested_blocks = 0

      # count number of nested blocks
      gemfile.each_with_index {|line, index| nested_blocks += 1 if !gemfile[index + 1].nil? && gemfile[index + 1].include?(block_name) && line.include?(block_name) }

      while nested_blocks >= 0
        nested_blocks -= 1

        gemfile.each_with_index do |line, index|
          next unless !line.nil? && line.strip.start_with?(block_name)
          if /^\s*end\s*$/.match?(gemfile[index + 1])
            gemfile[index] = nil
            gemfile[index + 1] = nil
          end
        end

        gemfile.compact!
      end
    end

    # @param [Pathname] gemfile_path   The Gemfile from which to remove dependencies.
    # @param [Array] original_deps     Array of original dependencies.
    # @param [Array] removed_deps      Array of removed dependencies.
    # @param [Array] initial_gemfile   Contents of original Gemfile before any operation.
    def cross_check_for_errors(gemfile_path, original_deps, removed_deps, initial_gemfile)
      # evaluate the new gemfile to look for any failure cases
      builder = Dsl.new
      builder.eval_gemfile(gemfile_path)

      # record gems which were removed but not requested
      extra_removed_gems = original_deps - builder.dependencies

      # if some extra gems were removed then raise error
      # and revert Gemfile to original
      unless extra_removed_gems.empty?
        SharedHelpers.write_to_gemfile(gemfile_path, initial_gemfile.join)

        raise InvalidOption, "Gems could not be removed. #{extra_removed_gems.join(", ")} would also have been removed. Bundler cannot continue."
      end

      # record gems which could not be removed due to some reasons
      errored_deps = builder.dependencies.select {|d| d.gemfile == gemfile_path } & removed_deps.select {|d| d.gemfile == gemfile_path }

      show_warning "#{errored_deps.map(&:name).join(", ")} could not be removed." unless errored_deps.empty?

      # return actual removed dependencies
      removed_deps - errored_deps
    end

    def show_warning(message)
      Bundler.ui.info Bundler.ui.add_color(message, :yellow)
    end

    def convert_autorequire(autorequire)
      autorequire = autorequire.first
      return autorequire if autorequire == "false"
      autorequire.inspect
    end

    def gemfile_declares?(gemfile_path, name)
      pattern = /gem\s+(['"])#{Regexp.escape(name)}\1|gem\s*\((['"])#{Regexp.escape(name)}\2/
      File.foreach(gemfile_path) do |line|
        match_data = line.match(pattern)
        return true if match_data && is_not_within_comment?(line, match_data)
      end
      false
    end

    # Returns the full text of the first `gem "name" ...` declaration in
    # the file (possibly spanning multiple comma-continued lines), or nil.
    def find_gem_declaration(gemfile_path, name)
      return unless File.file?(gemfile_path)

      pattern = /gem\s*(?:\(\s*)?(['"])#{Regexp.escape(name)}\1/
      block = []
      File.foreach(gemfile_path) do |line|
        block << line
        next if line.rstrip.end_with?(",")

        first = block.first
        text = block.join
        block = []
        match_data = first.match(pattern)
        return text if match_data && is_not_within_comment?(first, match_data)
      end
      nil
    end

    # Rewrites the version requirements of the given gems in a single Gemfile,
    # keeping options and comments intact. Multi-line declarations are
    # collapsed to a single line.
    def rewrite_gemfile_requirements(gemfile_path, requirements)
      lines = File.readlines(gemfile_path)
      updated = []
      rewritten = []
      block = []

      flush = lambda do
        unless block.empty?
          name = gem_declaration_name(block.first)
          if name && requirements.key?(name)
            rewritten << rewrite_gem_declaration(block.join, name, requirements[name])
            updated << name
          else
            rewritten << block.join
          end
          block = []
        end
      end

      lines.each do |line|
        block << line
        # a declaration continues while the line ends with a comma
        flush.call unless line.rstrip.end_with?(",")
      end
      flush.call

      SharedHelpers.write_to_gemfile(gemfile_path, rewritten.join.chomp) unless updated.empty?

      updated.uniq
    end

    def gem_declaration_name(first_line)
      match_data = first_line.match(/gem\s*(?:\(\s*)?(['"])(.+?)\1/)
      return unless match_data
      return if match_data.offset(0).first > 0 && first_line[0...match_data.offset(0).first].include?("#")
      match_data[2]
    end

    # Rewrites the version requirement arguments of a single `gem` declaration,
    # leaving everything else -- options, comments, and the original layout of
    # multi-line declarations -- untouched.
    def rewrite_gem_declaration(declaration, name, requirement)
      return collapsed_gem_declaration(declaration, name, requirement) if declaration_has_comment?(declaration)

      match_data = declaration.match(/\A(\s*gem\s*)(?:\(\s*)?(['"])(.+?)\2/)
      return declaration unless match_data && match_data[3] == name

      body_end = declaration_body_end(declaration, match_data)
      return declaration if body_end <= match_data.end(0)

      requirements = Array(requirement).map(&:dump).join(", ")
      spans = argument_spans(declaration, match_data.end(0), body_end)
      version_spans = spans.take_while {|span| version_argument?(declaration[span[0]...span[1]]) }

      if version_spans.empty?
        # No version declared yet: add the requirement before any options.
        insertion = match_data.end(0)
        "#{declaration[0...insertion]}, #{requirements}#{declaration[insertion..]}"
      else
        "#{declaration[0...version_spans.first[0]]}#{requirements}#{declaration[version_spans.last[1]..]}"
      end
    end

    # Rewrites a declaration onto a single line, the only option when the
    # declaration carries a comment: a comment runs to the end of its line, so
    # arguments cannot be spliced back in place around it.
    def collapsed_gem_declaration(declaration, name, requirement)
      code, comment = split_trailing_comment(declaration.chomp)
      match_data = code.match(/\A(\s*gem\s*)(?:\(\s*)?(['"])(.+?)\2/)
      return declaration unless match_data
      return declaration unless match_data[3] == name

      paren = code.match?(/\A\s*gem\s*\(/)
      indent = match_data[1][/^\s*/]
      quote = match_data[2]
      rest = code[match_data[0].length..] || ""
      rest = rest.sub(/\A\s*,\s*/, "")
      rest = rest.sub(/\s*\)\s*\z/, "") if paren

      args = split_top_level_commas(rest).map(&:strip).reject(&:empty?)
      options = args.drop_while {|arg| version_argument?(arg) }
      options_suffix = options.empty? ? "" : ", #{options.join(", ")}"
      requirements_suffix = Array(requirement).map(&:dump).join(", ")

      rewritten = "#{indent}gem#{paren ? "(" : " "}#{quote}#{name}#{quote}, #{requirements_suffix}#{options_suffix}#{paren ? ")" : ""}"
      comment.empty? ? "#{rewritten}\n" : "#{rewritten}#{comment}\n"
    end

    # @return [Boolean] whether any line of the declaration carries a comment.
    def declaration_has_comment?(declaration)
      declaration.each_line.any? {|line| line_comment_start(line) }
    end

    # Offset of the `#` starting a comment on a line, ignoring `#` inside
    # quotes. A `#` starts a comment wherever it appears, so unlike
    # `split_trailing_comment` this is evaluated per line: a comment ends at
    # the newline and the declaration can continue on the next line.
    def line_comment_start(line)
      quote = nil
      line.each_char.with_index do |char, index|
        if quote
          quote = nil if char == quote && line[index - 1] != "\\"
        elsif ["'", '"'].include?(char)
          quote = char
        elsif char == "#"
          return index
        end
      end
      nil
    end

    # Offset just past the argument list of the declaration: the matching
    # closing parenthesis for `gem(...)`, or the end of the text otherwise.
    def declaration_body_end(declaration, match_data)
      open_index = match_data[0].index("(")
      return declaration.length unless open_index

      matching_paren_offset(declaration, match_data.begin(0) + open_index) || declaration.length
    end

    # @return [Integer, nil] offset of the parenthesis closing the one at
    #   `open_index`, ignoring parentheses inside quotes.
    def matching_paren_offset(string, open_index)
      depth = 0
      quote = nil

      string.each_char.with_index do |char, index|
        next if index < open_index

        if quote
          quote = nil if char == quote && string[index - 1] != "\\"
        elsif ["'", '"'].include?(char)
          quote = char
        elsif char == "("
          depth += 1
        elsif char == ")"
          depth -= 1
          return index if depth.zero?
        end
      end
      nil
    end

    # @return [Array<Array(Integer, Integer)>] inclusive start and exclusive
    #   end offset of every comma separated argument between `from` and `to`,
    #   with surrounding whitespace trimmed off. Commas inside quotes or
    #   nested brackets do not separate arguments.
    def argument_spans(string, from, to)
      spans = []
      first = nil
      last = nil
      quote = nil
      depth = 0

      flush = lambda do
        spans << [first, last + 1] if first
        first = last = nil
      end

      string.each_char.with_index do |char, index|
        next if index < from
        break if index >= to

        if quote
          quote = nil if char == quote && string[index - 1] != "\\"
          last = index
        elsif ["'", '"'].include?(char)
          quote = char
          first ||= index
          last = index
        elsif ["(", "[", "{"].include?(char)
          depth += 1
          first ||= index
          last = index
        elsif [")", "]", "}"].include?(char)
          depth -= 1
          last = index
        elsif char == "," && depth.zero?
          flush.call
        elsif char.match?(/\s/)
          # whitespace does not extend the span of an argument
        else
          first ||= index
          last = index
        end
      end
      flush.call
      spans
    end

    def version_argument?(arg)
      match_data = arg.match(/\A(['"])(.*)\1\z/m)
      return false unless match_data
      Gem::Requirement::PATTERN.match?(match_data[2])
    rescue ArgumentError
      false
    end

    # Splits a comma separated argument list, ignoring commas inside
    # quotes or nested brackets.
    def split_top_level_commas(string)
      parts = []
      current = String.new
      quote = nil
      depth = 0

      string.each_char.with_index do |char, index|
        if quote
          current << char
          quote = nil if char == quote && string[index - 1] != "\\"
        elsif ["'", '"'].include?(char)
          quote = char
          current << char
        elsif ["(", "[", "{"].include?(char)
          depth += 1
          current << char
        elsif [")", "]", "}"].include?(char)
          depth -= 1
          current << char
        elsif char == "," && depth.zero?
          parts << current
          current = String.new
        else
          current << char
        end
      end
      parts << current
      parts
    end

    # Splits off a trailing `# comment`, ignoring `#` inside quotes.
    def split_trailing_comment(string)
      quote = nil
      string.each_char.with_index do |char, index|
        if quote
          quote = nil if char == quote && string[index - 1] != "\\"
        elsif ["'", '"'].include?(char)
          quote = char
        elsif char == "#"
          return [string[0...index].rstrip, "  #{string[index..].rstrip}"]
        end
      end
      [string, ""]
    end
  end
end
