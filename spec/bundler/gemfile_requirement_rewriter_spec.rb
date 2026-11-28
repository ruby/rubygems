# frozen_string_literal: true

RSpec.describe Bundler::GemfileRequirementRewriter do
  def rewriter(source)
    described_class.new(source)
  end

  def rewrite(source, requirements)
    rewriter(source).rewrite(requirements)
  end

  describe "#requirements_for" do
    it "returns the requirements as written" do
      expect(rewriter(%(gem "foo", "~> 1.0"\n)).requirements_for("foo")).to eq(["~> 1.0"])
    end

    it "keeps a bare version bare" do
      expect(rewriter(%(gem "foo", "1.0"\n)).requirements_for("foo")).to eq(["1.0"])
    end

    it "returns every requirement of a compound declaration" do
      expect(rewriter(%(gem "foo", ">= 1.0", "< 2.0", require: false\n)).requirements_for("foo")).to eq([">= 1.0", "< 2.0"])
    end

    it "returns no requirements for a declaration without a version" do
      expect(rewriter(%(gem "foo", require: false\n)).requirements_for("foo")).to eq([])
    end

    it "returns nil when the gem is not declared" do
      expect(rewriter(%(gem "foo"\n)).requirements_for("bar")).to be_nil
    end

    it "reads single quoted and percent literals" do
      expect(rewriter(%(gem 'foo', '~> 1.0', %q(< 2)\n)).requirements_for("foo")).to eq(["~> 1.0", "< 2"])
    end

    it "reads parenthesized declarations spanning several lines" do
      source = <<~G
        gem(
          "foo", # the name
          # the requirement
          "~> 1.0"
        )
      G

      expect(rewriter(source).requirements_for("foo")).to eq(["~> 1.0"])
    end

    it "stops at the first argument that is not a requirement" do
      expect(rewriter(%(gem "foo", "~> 1.0", "nope", "< 2"\n)).requirements_for("foo")).to eq(["~> 1.0"])
    end

    it "does not read an interpolated string as a requirement" do
      expect(rewriter(%(gem "foo", "~> \#{v}"\n)).requirements_for("foo")).to eq([])
    end

    it "does not read a requirement from the next statement" do
      expect(rewriter(%(gem "foo"\n"1.0"\n)).requirements_for("foo")).to eq([])
    end

    it "reads a requirement followed by a modifier or a method call" do
      expect(rewriter(%(gem "foo", "~> 1.0" if true\n)).requirements_for("foo")).to eq(["~> 1.0"])
      expect(rewriter(%(gem "foo", "~> 1.0".freeze\n)).requirements_for("foo")).to eq(["~> 1.0"])
    end

    it "returns the requirements of the first declaration" do
      source = <<~G
        if ENV["NEW"]
          gem "foo", "~> 2.0"
        else
          gem "foo", "~> 1.0"
        end
      G

      expect(rewriter(source).requirements_for("foo")).to eq(["~> 2.0"])
    end
  end

  describe "#declares?" do
    it "finds declarations after comments, separators and block openings" do
      source = <<~G
        gem "a" # a comment
        gem "b"; gem "c"
        group :test do gem "d" end
        group(:test) { gem "e" }
        =begin
        =end
        gem "f"
      G

      expect(%w[a b c d e f].select {|name| rewriter(source).declares?(name) }).to eq(%w[a b c d e f])
    end

    it "ignores `gem` in comments, strings and heredocs" do
      source = <<~G
        # gem "a"
        x = "gem 'b'"
        y = <<~E
          gem "c"
        E
      G

      expect(%w[a b c].select {|name| rewriter(source).declares?(name) }).to be_empty
    end

    it "does not find gems that are not declared" do
      expect(rewriter(%(gem "foo"\ngem "bar"\n)).declares?("baz")).to be(false)
    end

    it "ignores calls that are not to the Gemfile `gem` method" do
      source = <<~G
        gemspec name: "a"
        self.
          gem "b"
        x&.gem "c"
        Kernel::gem "d"
        gem name
        gem "e\#{x}"
        def gem(*); end
        alias gem gem2
        x = :gem
      G

      expect(%w[a b c d e x].select {|name| rewriter(source).declares?(name) }).to be_empty
    end

    it "finds `gem` calls nested in other expressions" do
      source = <<~G
        x = 1 # set x
        gem "a"
        y = # comment
          gem "b"
        foo(1,
          # gem as an argument
          gem("c"))
      G

      expect(%w[a b c].select {|name| rewriter(source).declares?(name) }).to eq(%w[a b c])
    end

    it "ignores declarations that give their requirements as an array" do
      expect(rewriter(%(gem "foo", ["~> 1.0"]\n)).declares?("foo")).to be(false)
      expect(rewriter(%(gem "foo", %w[1.0]\n)).declares?("foo")).to be(false)
      expect(rewriter(%(gem "foo", "~> 1.0", %W[1.0]\n)).declares?("foo")).to be(false)
    end

    it "handles source ending in the middle of a declaration" do
      expect(rewriter("gem").declares?("gem")).to be(false)
      expect(rewriter("gem(").declares?("gem")).to be(false)
      expect(rewriter(%(gem "foo)).declares?("foo")).to be(false)
      expect(rewriter(%(gem "foo", ")).requirements_for("foo")).to eq([])
      expect(rewriter(%(gem "foo", "~> 1.0)).requirements_for("foo")).to eq([])
      expect(rewriter(%(gem "foo", "~> 1.0")).requirements_for("foo")).to eq(["~> 1.0"])
    end
  end

  describe "#rewrite" do
    it "replaces the requirement and keeps options and comments" do
      expect(rewrite(%(gem "foo", "~> 1.0", require: false # keep\n), "foo" => "~> 2.0")).
        to eq(%(gem "foo", "~> 2.0", require: false # keep\n))
    end

    it "replaces single quoted requirements" do
      expect(rewrite(%(gem 'foo', '~> 1.0'\n), "foo" => "~> 2.0")).to eq(%(gem 'foo', "~> 2.0"\n))
    end

    it "adds a requirement to a declaration without one" do
      expect(rewrite(%(gem "foo"\n), "foo" => "~> 2.0")).to eq(%(gem "foo", "~> 2.0"\n))
      expect(rewrite(%(gem("foo")\n), "foo" => "~> 2.0")).to eq(%(gem("foo", "~> 2.0")\n))
      expect(rewrite(%(gem "foo", require: false\n), "foo" => "~> 2.0")).to eq(%(gem "foo", "~> 2.0", require: false\n))
    end

    it "adds requirements after the existing ones" do
      expect(rewrite(%(gem "foo", "~> 1.0", require: false\n), "foo" => ["> 1.0", "< 2.0"])).
        to eq(%(gem "foo", "> 1.0", "< 2.0", require: false\n))
    end

    it "adds requirements after every existing one" do
      expect(rewrite(%(gem "foo", "> 1", "< 3", require: false\n), "foo" => ["> 1", "< 2", "!= 1.5"])).
        to eq(%(gem "foo", "> 1", "< 2", "!= 1.5", require: false\n))
    end

    it "rewrites a declaration at the end of the source" do
      expect(rewrite(%(gem "foo", "~> 1.0"), "foo" => "~> 2.0")).to eq(%(gem "foo", "~> 2.0"))
      expect(rewrite(%(gem "foo"), "foo" => "~> 2.0")).to eq(%(gem "foo", "~> 2.0"))
    end

    it "removes the blanks around a removed requirement" do
      expect(rewrite(%(gem "foo", "> 1","< 2"\n), "foo" => ">= 2")).to eq(%(gem "foo", ">= 2"\n))
      expect(rewrite(%(gem "foo", "> 1",\t"< 2"\n), "foo" => ">= 2")).to eq(%(gem "foo", ">= 2"\n))
      expect(rewrite(%(gem "foo", "> 1", "< 2",\t require: false\n), "foo" => ">= 2")).to eq(%(gem "foo", ">= 2", require: false\n))
    end

    it "removes the CRLF terminated line of a removed requirement followed by options" do
      source = %(gem "foo", "> 1.0",\r\n  "< 2.0",\r\n  require: false\r\n)

      expect(rewrite(source, "foo" => ">= 2.0")).to eq(%(gem "foo", ">= 2.0",\r\n  require: false\r\n))
    end

    it "removes extra requirements at the end of the declaration" do
      expect(rewrite(%(gem "foo", "> 1.0", "< 2.0", "!= 1.5"\n), "foo" => ">= 2.0")).
        to eq(%(gem "foo", ">= 2.0"\n))
    end

    it "removes extra requirements followed by options" do
      expect(rewrite(%(gem "foo", "> 1.0", "< 2.0", "!= 1.5", require: false\n), "foo" => ">= 2.0")).
        to eq(%(gem "foo", ">= 2.0", require: false\n))
    end

    it "removes the line of an extra requirement at the end of a multi-line declaration" do
      source = <<~G
        gem "foo", "> 1.0", # floor
          "< 2.0"
        gem "bar"
      G

      expect(rewrite(source, "foo" => ">= 2.0")).to eq(<<~G)
        gem "foo", ">= 2.0" # floor
        gem "bar"
      G
    end

    it "removes the line of an extra requirement followed by options" do
      source = <<~G
        gem "foo", "> 1.0", # floor
          "< 2.0",
          require: false
      G

      expect(rewrite(source, "foo" => ">= 2.0")).to eq(<<~G)
        gem "foo", ">= 2.0", # floor
          require: false
      G
    end

    it "keeps a comment on the line of a removed requirement" do
      source = <<~G
        gem "foo", "> 1.0",
          "< 2.0", # ceiling
          require: false
      G

      expect(rewrite(source, "foo" => ">= 2.0")).to eq(<<~G)
        gem "foo", ">= 2.0",
          # ceiling
          require: false
      G
    end

    it "keeps the layout of multi-line declarations" do
      source = <<~G
        gem(
          "foo", # the name
          "~> 1.0",
          require: false,
        )
      G

      expect(rewrite(source, "foo" => "~> 2.0")).to eq(source.sub("~> 1.0", "~> 2.0"))
    end

    it "keeps trailing modifiers and method calls" do
      expect(rewrite(%(gem "foo", "1.0" unless x # keep\n), "foo" => "2.0")).to eq(%(gem "foo", "2.0" unless x # keep\n))
      expect(rewrite(%(gem "foo", "~> 1.0".freeze\n), "foo" => "~> 2.0")).to eq(%(gem "foo", "~> 2.0".freeze\n))
    end

    it "does not mistake # in literals for comments" do
      source = %(gem "foo", "~> 1.0", require: %w[foo#bar], platforms: /a#b/ # keep\n)

      expect(rewrite(source, "foo" => "~> 2.0")).to eq(source.sub("~> 1.0", "~> 2.0"))
    end

    it "rewrites every declaration of the gem" do
      source = <<~G
        if ENV["NEW"]
          gem "foo", "~> 1.0"
        else
          gem "foo"
        end
      G

      expect(rewrite(source, "foo" => "~> 2.0")).to eq(<<~G)
        if ENV["NEW"]
          gem "foo", "~> 2.0"
        else
          gem "foo", "~> 2.0"
        end
      G
    end

    it "leaves other gems, comments and heredocs alone" do
      source = <<~G
        # gem "foo", "~> 1.0"
        gem "foobar", "~> 1.0"
        x = <<~E
          gem "foo", "~> 1.0"
        E
        gem "foo", "~> 1.0"
      G

      expect(rewrite(source, "foo" => "~> 2.0", "baz" => "1.0")).to eq(source.sub(/^gem "foo", "~> 1.0"/, %(gem "foo", "~> 2.0")))
    end

    it "handles multibyte characters and CRLF line endings" do
      source = %(# caf\u00e9 \u2615\r\ngem "foo", "> 1.0", # \u00fcber\r\n  "< 2.0"\r\ngem "bar"\r\n)

      expect(rewrite(source, "foo" => ">= 2.0")).to eq(%(# caf\u00e9 \u2615\r\ngem "foo", ">= 2.0" # \u00fcber\r\ngem "bar"\r\n))
    end

    it "returns the source unchanged when no requirement applies" do
      source = %(gem "foo", "~> 1.0"\n)

      expect(rewrite(source, "bar" => "~> 2.0")).to eq(source)
    end
  end
end
