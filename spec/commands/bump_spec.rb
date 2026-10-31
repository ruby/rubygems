# frozen_string_literal: true

RSpec.describe "bundle bump" do
  before :each do
    build_repo2 do
      build_gem "myrake", "13.0.0"
      build_gem "myrake-compiler", "1.0.0"
      build_gem "foo", "1.0"
      build_gem "foo", "1.0.1"
      build_gem "foo", "2.0"
    end

    install_gemfile <<-G
      source "https://gem.repo2"
      gem "myrake", "~> 13.0"
      gem "myrake-compiler", "~> 1.0"
      gem "foo", "~> 1.0"
    G
  end

  it "rewrites the Gemfile requirement and updates the lockfile" do
    update_repo2 do
      build_gem "myrake", "13.1.0"
    end

    bundle "bump myrake"

    expect(out).to include("Bundle bumped!")
    expect(err).to be_empty
    expect(bundled_app_gemfile.read).to match(/gem "myrake", "~> 13\.1\.0"/)
    expect(the_bundle).to include_gems "myrake 13.1.0"
    expect(the_bundle).to include_gems "foo 1.0.1"
  end

  it "pins to an explicit version with gem@version" do
    bundle "bump foo@1.0"

    expect(out).to include("foo updated from 1.0.1 to 1.0")
    expect(out).to include("Bundle bumped!")
    expect(bundled_app_gemfile.read).to match(/gem "foo", "= 1\.0"/)
    expect(the_bundle).to include_gems "foo 1.0"
  end

  it "supports glob patterns" do
    update_repo2 do
      build_gem "myrake", "13.1.0"
      build_gem "myrake-compiler", "1.2.0"
    end

    bundle 'bump "myrake*"'

    expect(out).to include("Bundle bumped!")
    expect(bundled_app_gemfile.read).to match(/gem "myrake", "~> 13\.1\.0"/)
    expect(bundled_app_gemfile.read).to match(/gem "myrake-compiler", "~> 1\.2\.0"/)
    expect(the_bundle).to include_gems "myrake 13.1.0", "myrake-compiler 1.2.0"
  end

  it "matches a leading glob without matching longer names" do
    update_repo2 do
      build_gem "myrake", "13.1.0"
      build_gem "myrake-compiler", "1.2.0"
    end

    bundle 'bump "*rake"'

    expect(out).to include("Bundle bumped!")
    expect(bundled_app_gemfile.read).to match(/gem "myrake", "~> 13\.1\.0"/)
    expect(bundled_app_gemfile.read).to match(/gem "myrake-compiler", "~> 1\.0"/)
    expect(the_bundle).to include_gems "myrake 13.1.0", "myrake-compiler 1.0.0"
  end

  it "matches a leading and trailing glob" do
    update_repo2 do
      build_gem "myrake", "13.1.0"
      build_gem "myrake-compiler", "1.2.0"
    end

    bundle 'bump "*rake*"'

    expect(out).to include("Bundle bumped!")
    expect(bundled_app_gemfile.read).to match(/gem "myrake", "~> 13\.1\.0"/)
    expect(bundled_app_gemfile.read).to match(/gem "myrake-compiler", "~> 1\.2\.0"/)
    expect(the_bundle).to include_gems "myrake 13.1.0", "myrake-compiler 1.2.0"
  end

  it "matches every declared gem with a bare glob" do
    update_repo2 do
      build_gem "myrake", "13.1.0"
      build_gem "myrake-compiler", "1.2.0"
      build_gem "foo", "2.0"
    end

    bundle 'bump "*"'

    expect(out).to include("Bundle bumped!")
    expect(bundled_app_gemfile.read).to match(/gem "myrake", "~> 13\.1\.0"/)
    expect(bundled_app_gemfile.read).to match(/gem "myrake-compiler", "~> 1\.2\.0"/)
    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0"/)
    expect(the_bundle).to include_gems "myrake 13.1.0", "myrake-compiler 1.2.0", "foo 2.0"
  end

  it "reports an error when no pattern matches" do
    bundle "bump nosuchgem", raise_on_error: false

    expect(err).to include("Could not find gem 'nosuchgem'")
  end

  it "requires at least one pattern" do
    bundle "bump", raise_on_error: false

    expect(err).to include("Please specify gems to update")
  end

  it "updates everything with --all" do
    update_repo2 do
      build_gem "myrake", "13.1.0"
      build_gem "foo", "2.0"
    end

    bundle "bump", all: true

    expect(out).to include("Bundle bumped!")
    expect(bundled_app_gemfile.read).to match(/gem "myrake", "~> 13\.1\.0"/)
    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0"/)
    expect(the_bundle).to include_gems "myrake 13.1.0", "foo 2.0"
  end

  it "rejects combining --all with patterns" do
    bundle "bump foo --all", raise_on_error: false

    expect(err).to include("Cannot specify --all along with specific options")
  end

  it "writes an exact requirement with --exact" do
    bundle "bump foo --exact"

    expect(err).to be_empty
    expect(bundled_app_gemfile.read).to match(/gem "foo", "= 2\.0"/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "writes a pessimistic requirement with --tilde" do
    bundle "bump foo --tilde"

    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0"/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "writes an optimistic requirement with --gte" do
    bundle "bump foo --gte"

    expect(bundled_app_gemfile.read).to match(/gem "foo", ">= 2\.0"/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "writes a ceiling requirement with --lte" do
    bundle "bump foo --lte"

    expect(bundled_app_gemfile.read).to match(/gem "foo", "<= 2\.0"/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "rejects combining --version with operator flags" do
    bundle "bump foo --version='> 1.0' --exact", raise_on_error: false

    expect(err).to include("Provide only one of --version and --exact")
  end

  it "rejects combining gem@version pins with --version" do
    bundle "bump foo@1.0 --version='> 1.0'", raise_on_error: false

    expect(err).to include("Cannot combine `gem@version` pins with --version")
  end

  it "rejects invalid version pins" do
    bundle "bump foo@blah", raise_on_error: false

    expect(err).to include("Invalid version pin")
  end

  it "writes compound requirements from gem@version pins" do
    bundle 'bump "foo@> 1.0, < 2.0"'

    expect(out).to include("Bundle bumped!")
    expect(bundled_app_gemfile.read).to match(/gem "foo", "> 1\.0", "< 2\.0"/)
    expect(the_bundle).to include_gems "foo 1.0.1"
  end

  it "writes compound requirements from --version" do
    bundle "bump foo --version='> 1.0, < 2.0'"

    expect(out).to include("Bundle bumped!")
    expect(bundled_app_gemfile.read).to match(/gem "foo", "> 1\.0", "< 2\.0"/)
    expect(the_bundle).to include_gems "foo 1.0.1"
  end

  it "rewrites the requirement with --gte even when already at the latest version" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", "= 2.0"
    G

    bundle "bump foo --gte"

    expect(out).to include('requirement updated to ">= 2.0"')
    expect(bundled_app_gemfile.read).to match(/gem "foo", ">= 2\.0"/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "stays quiet when the requirement already matches" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", ">= 2.0"
    G

    bundle "bump foo --gte"

    expect(out).to include("Bundle up to date!")
    expect(bundled_app_gemfile.read).to match(/gem "foo", ">= 2\.0"/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "respects --patch --strict by leaving the gem alone" do
    bundle "bump foo --patch --strict"

    expect(out).to include("Bundle up to date!")
    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 1\.0"/)
    expect(the_bundle).to include_gems "foo 1.0.1"
  end

  it "updates only gems in the given group" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "myrake", "~> 13.0", group: :development
      gem "foo", "~> 1.0"
    G

    update_repo2 do
      build_gem "myrake", "13.1.0"
    end

    bundle "bump myrake foo --group development"

    expect(bundled_app_gemfile.read).to match(/gem "myrake", "~> 13\.1\.0"/)
    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 1\.0"/)
    expect(the_bundle).to include_gems "myrake 13.1.0", "foo 1.0.1"
  end

  context "when the Gemfile uses strict inequality operators" do
    before :each do
      build_repo2 do
        build_gem "foo", "1.0"
        build_gem "foo", "1.0.1"
      end
    end

    it "rewrites a bare declaration with a pessimistic requirement" do
      install_gemfile <<-G
        source "https://gem.repo2"
        gem "foo"
      G

      update_repo2 do
        build_gem "foo", "2.0"
      end

      bundle "bump foo"

      expect(err).to be_empty
      expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0"/)
      expect(the_bundle).to include_gems "foo 2.0"
    end

    it "rewrites > as >=" do
      install_gemfile <<-G
        source "https://gem.repo2"
        gem "foo", "> 1.0"
      G

      update_repo2 do
        build_gem "foo", "2.0"
      end

      bundle "bump foo"

      expect(err).to include("Rewriting `> 1.0` as `>= 2.0`")
      expect(bundled_app_gemfile.read).to match(/gem "foo", ">= 2\.0"/)
      expect(the_bundle).to include_gems "foo 2.0"
    end

    it "rewrites < as pessimistic" do
      install_gemfile <<-G
        source "https://gem.repo2"
        gem "foo", "< 2.0"
      G

      update_repo2 do
        build_gem "foo", "2.0"
      end

      bundle "bump foo"

      expect(err).to include("Rewriting `< 2.0` as `~> 2.0`, since ceilings cannot be preserved")
      expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0"/)
      expect(the_bundle).to include_gems "foo 2.0"
    end

    it "rewrites <= as pessimistic" do
      install_gemfile <<-G
        source "https://gem.repo2"
        gem "foo", "<= 1.0.1"
      G

      update_repo2 do
        build_gem "foo", "2.0"
      end

      bundle "bump foo"

      expect(err).to include("Rewriting `<= 1.0.1` as `~> 2.0`, since ceilings cannot be preserved")
      expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0"/)
      expect(the_bundle).to include_gems "foo 2.0"
    end

    it "rewrites != as pessimistic" do
      install_gemfile <<-G
        source "https://gem.repo2"
        gem "foo", "!= 1.0"
      G

      update_repo2 do
        build_gem "foo", "2.0"
      end

      bundle "bump foo"

      expect(err).to include("Rewriting `!= 1.0` as `~> 2.0`, since ceilings cannot be preserved")
      expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0"/)
      expect(the_bundle).to include_gems "foo 2.0"
    end

    it "keeps bare versions bare" do
      install_gemfile <<-G
        source "https://gem.repo2"
        gem "foo", "1.0.1"
      G

      update_repo2 do
        build_gem "foo", "2.0"
      end

      bundle "bump foo"

      expect(err).to be_empty
      expect(bundled_app_gemfile.read).to match(/gem "foo", "2\.0"/)
      expect(bundled_app_gemfile.read).not_to match(/gem "foo", "= 2\.0"/)
      expect(the_bundle).to include_gems "foo 2.0"
    end

    it "leaves an already latest bare version alone" do
      install_gemfile <<-G
        source "https://gem.repo2"
        gem "foo", "2.0"
      G

      bundle "bump foo"

      expect(out).to include("Bundle up to date!")
      expect(bundled_app_gemfile.read).to match(/gem "foo", "2\.0"/)
    end

    it "preserves = requirements" do
      install_gemfile <<-G
        source "https://gem.repo2"
        gem "foo", "= 1.0.1"
      G

      update_repo2 do
        build_gem "foo", "2.0"
      end

      bundle "bump foo"

      expect(bundled_app_gemfile.read).to match(/gem "foo", "= 2\.0"/)
      expect(the_bundle).to include_gems "foo 2.0"
    end
  end

  it "keeps other Gemfile options when rewriting" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "myrake", "~> 13.0", group: :development, require: false
    G

    update_repo2 do
      build_gem "myrake", "13.1.0"
    end

    bundle "bump myrake"

    expect(bundled_app_gemfile.read).to match(/gem "myrake", "~> 13\.1\.0", group: :development, require: false/)
    expect(the_bundle).to include_gems "myrake 13.1.0"
  end

  context "when a version level is requested" do
    before :each do
      build_repo2 do
        build_gem "foo", "1.0"
        build_gem "foo", "1.0.1"
      end

      install_gemfile <<-G
        source "https://gem.repo2"
        gem "foo", "~> 1.0"
      G
    end

    it "updates only within the current patch level with --patch" do
      update_repo2 do
        build_gem "foo", "1.0.2"
        build_gem "foo", "2.0"
      end

      bundle "bump foo --patch"

      expect(out).to include("Bundle bumped!")
      expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 1\.0\.2"/)
      expect(the_bundle).to include_gems "foo 1.0.2"
    end

    it "leaves a gem alone with --patch when nothing newer exists in its level" do
      update_repo2 do
        build_gem "foo", "1.1.0"
        build_gem "foo", "2.0"
      end

      bundle "bump foo --patch"

      expect(out).to include("Bundle up to date!")
      expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 1\.0"/)
      expect(the_bundle).to include_gems "foo 1.0.1"
    end

    it "updates only within the current major version with --minor" do
      update_repo2 do
        build_gem "foo", "1.1.0"
        build_gem "foo", "2.0"
      end

      bundle "bump foo --minor"

      expect(out).to include("Bundle bumped!")
      expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 1\.1\.0"/)
      expect(the_bundle).to include_gems "foo 1.1.0"
    end
  end

  it "accepts the default answer when --interactive cannot read from stdin" do
    bundle "bump foo --interactive"

    expect(out).to include(%(Update foo from 1.0.1 to 2.0 ("~> 2.0")? (Y/n)))
    expect(out).to include("Bundle bumped!")
    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0"/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "shows the resolved version and the requirement in the prompt when confirming a compound pin" do
    bundle "bump 'foo@> 1.0, < 2.0' --interactive"

    expect(out).to include(%(Update foo from 1.0.1 to 1.0.1 ("> 1.0", "< 2.0")? (Y/n)))
    expect(bundled_app_gemfile.read).to match(/gem "foo", "> 1\.0", "< 2\.0"/)
    expect(the_bundle).to include_gems "foo 1.0.1"
  end

  it "does not touch the Gemfile when a pin cannot be resolved" do
    build_repo2 do
      build_gem "foo", "2.0"
      build_gem "foo", "1.0" do |s|
        s.add_dependency "missingdep", "= 999"
      end
    end

    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", "~> 2.0"
    G

    bundle "bump foo@1.0", raise_on_error: false

    expect(err).to include("Could not find compatible versions")
    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0"/)
    expect(bundled_app_lock.read).to include("foo (2.0)")
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "does not rewrite the Gemfile when frozen mode is set" do
    bundle "config set --local frozen true"
    bundle "bump foo", raise_on_error: false

    expect(err).to include("frozen mode is set")
    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 1\.0"/)
    expect(bundled_app_lock.read).to include("foo (1.0.1)")
  end

  it "skips a gem from a path source with a warning" do
    build_lib "foo", path: lib_path("foo")

    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", path: "#{lib_path("foo")}"
    G

    bundle "bump foo"

    expect(err).to include("Bundler attempted to bump foo but it comes from Bundler::Source::Path, skipping.")
    expect(out).to include("Bundle up to date!")
  end

  it "skips a gem from a git source with a warning" do
    build_git "foo", path: lib_path("foo")

    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", git: "#{lib_path("foo")}"
    G

    bundle "bump foo"

    expect(err).to include("Bundler attempted to bump foo but it comes from Bundler::Source::Git, skipping.")
    expect(out).to include("Bundle up to date!")
  end

  it "skips a gem that is not in the bundle for the current platform" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", "~> 1.0"
      gem "platform_specific", platforms: :jruby
    G

    bundle "bump --all"

    expect(err).to include("Bundler attempted to bump platform_specific but it is not in the bundle for the current platform, skipping.")
    expect(out).to include("Bundle bumped!")
    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0"/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "suggests similar gem names when no pattern matches" do
    bundle "bump myrak", raise_on_error: false

    expect(err).to include("Could not find gem 'myrak'")
    expect(err).to include("Did you mean 'myrake'?")
  end

  it "preserves multi-line declarations when rewriting" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo",
        "~> 1.0",
        require: false
    G

    bundle "bump foo"

    expect(bundled_app_gemfile.read).to match(/gem "foo",\n  "~> 2\.0",\n  require: false/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "preserves a trailing comment when rewriting" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", "~> 1.0" # keep this
    G

    bundle "bump foo"

    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0".*# keep this/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "preserves a comment on a non-last line of a multi-line declaration" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", "~> 1.0", # keep this
        require: false
    G

    bundle "bump foo"

    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0", # keep this\n  require: false/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "preserves a comment on its own line inside a multi-line declaration" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", "~> 1.0",
        # keep this
        require: false
    G

    bundle "bump foo"

    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0",\n  # keep this\n  require: false/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "preserves a comment on the last line of a multi-line declaration" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", "~> 1.0",
        require: false # keep this
    G

    bundle "bump foo"

    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0",\n  require: false # keep this/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "preserves every comment of a multi-line declaration" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", # first
        "~> 1.0", # second
        require: false # third
    G

    bundle "bump foo"

    expect(bundled_app_gemfile.read).to match(/gem "foo", # first\n  "~> 2\.0", # second\n  require: false # third/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "does not treat a # inside a percent literal as a comment" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", "~> 1.0", require: %w[foo#bar]
    G

    bundle "bump foo"

    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0", require: %w\[foo#bar\]/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "does not treat a # inside a regexp literal as a comment" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", "~> 1.0", require: /foo#bar/
    G

    bundle "bump foo"

    expect(bundled_app_gemfile.read).to match(%r{gem "foo", "~> 2\.0", require: /foo#bar/})
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "keeps a standalone comment between declarations" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", "~> 1.0" # keep this
      # standalone
      gem "myrake", "~> 13.0"
    G

    bundle "bump foo"

    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0".*# keep this/)
    expect(bundled_app_gemfile.read).to match(/# standalone\n\s*gem "myrake", "~> 13\.0"/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "rewrites a version argument with a trailing modifier" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", "~> 1.0" if RUBY_VERSION >= "1.0"
    G

    bundle "bump foo"

    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0" if RUBY_VERSION >= "1\.0"/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "rewrites a version argument with a trailing method call" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", "~> 1.0".freeze
    G

    bundle "bump foo"

    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0"\.freeze/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "keeps a bare version bare when a modifier follows it" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", "1.0" unless ENV["BUNDLE_BUMP_UNSET"]
    G

    bundle "bump foo"

    expect(bundled_app_gemfile.read).to match(/gem "foo", "2\.0" unless ENV\["BUNDLE_BUMP_UNSET"\]/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "rewrites a version argument with a trailing modifier and a comment" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", "~> 1.0" if RUBY_VERSION >= "1.0" # keep this
    G

    bundle "bump foo"

    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0" if RUBY_VERSION >= "1\.0".*# keep this/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "restores the Gemfile and the lockfile when the install fails" do
    update_repo2 do
      build_gem "foo", "2.1" do |s|
        s.extensions << "Rakefile"
        s.write "Rakefile", <<-RUBY
          task :default do
            abort "make installing foo-2.1 fail"
          end
        RUBY
      end
    end

    bundle "bump foo", raise_on_error: false

    expect(err).to include("An error occurred while installing foo (2.1)")
    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 1\.0"/)
    expect(bundled_app_lock.read).to include("foo (1.0.1)")
  end

  context "when choosing the version to move to" do
    it "picks the newest version that supports the current Ruby" do
      build_repo2 do
        build_gem "foo", "1.0"
        build_gem "foo", "2.0"
        build_gem "foo", "3.0" do |s|
          s.required_ruby_version = "> 99"
        end
        build_gem "bar", "1.0"
        build_gem "bar", "2.0"
      end

      install_gemfile <<-G
        source "https://gem.repo2"
        gem "foo", "~> 1.0"
        gem "bar", "~> 1.0"
      G

      bundle "bump --all"

      expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0"/)
      expect(bundled_app_gemfile.read).to match(/gem "bar", "~> 2\.0"/)
      expect(the_bundle).to include_gems "foo 2.0", "bar 2.0"
    end

    it "picks the newest version that resolves with the rest of the bundle" do
      build_repo2 do
        build_gem "baz", "1.0"
        build_gem "baz", "2.0"
        build_gem "foo", "1.0" do |s|
          s.add_dependency "baz", "~> 1.0"
        end
        build_gem "foo", "1.5" do |s|
          s.add_dependency "baz", "~> 1.0"
        end
        build_gem "foo", "2.0" do |s|
          s.add_dependency "baz", "~> 2.0"
        end
      end

      install_gemfile <<-G
        source "https://gem.repo2"
        gem "foo", "~> 1.0.0"
        gem "baz", "~> 1.0"
      G

      bundle "bump foo"

      expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 1\.5"/)
      expect(bundled_app_gemfile.read).to match(/gem "baz", "~> 1\.0"/)
      expect(the_bundle).to include_gems "foo 1.5", "baz 1.0"
    end

    it "skips versions inside the cooldown window" do
      now = Time.now.utc
      build_repo3 do
        build_gem "mid_gem", "1.0.0" do |s|
          s.date = now - (30 * 86_400)
        end
        build_gem "mid_gem", "1.5.0" do |s|
          s.add_dependency "child"
          s.date = now - (30 * 86_400)
        end
        build_gem "mid_gem", "2.0.0" do |s|
          s.date = now - (1 * 86_400)
        end
        build_gem "child", "1.0.0" do |s|
          s.date = now - (30 * 86_400)
        end
        build_gem "child", "2.0.0" do |s|
          s.date = now - (1 * 86_400)
        end
      end

      install_gemfile <<-G, artifice: "compact_index_v2"
        source "https://gem.repo3"
        gem "mid_gem", "~> 1.0.0"
      G

      bundle "bump mid_gem --cooldown 7", artifice: "compact_index_v2"

      expect(out).to include("The following gem versions were skipped by the cooldown setting")
      expect(out).to match(/child 2\.0\.0 \(available in \d+ days?\), resolved 1\.0\.0 instead/)
      expect(bundled_app_gemfile.read).to match(/gem "mid_gem", "~> 1\.5\.0"/)
      expect(the_bundle).to include_gems "mid_gem 1.5.0", "child 1.0.0"
    end

    it "ignores prereleases by default" do
      update_repo2 do
        build_gem "foo", "2.1.beta1"
      end

      bundle "bump foo"

      expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0"/)
      expect(the_bundle).to include_gems "foo 2.0"
    end

    it "considers prereleases with --pre" do
      update_repo2 do
        build_gem "foo", "2.1.beta1"
      end

      bundle "bump foo --pre"

      expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.1\.beta1"/)
      expect(the_bundle).to include_gems "foo 2.1.beta1"
    end

    it "pins to a prerelease version" do
      update_repo2 do
        build_gem "foo", "2.1.beta1"
      end

      bundle "bump foo@2.1.beta1"

      expect(bundled_app_gemfile.read).to match(/gem "foo", "= 2\.1\.beta1"/)
      expect(the_bundle).to include_gems "foo 2.1.beta1"
    end

    it "keeps the rest of the resolution inside the level with --minor --strict" do
      update_repo2 do
        build_gem "foo", "1.1.0"
      end

      bundle "bump foo --minor --strict"

      expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 1\.1\.0"/)
      expect(the_bundle).to include_gems "foo 1.1.0"
    end

    it "only considers locally available gems with --local" do
      bundle "bump foo --local"

      expect(out).to include("Bundle up to date!")
      expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 1\.0"/)
      expect(the_bundle).to include_gems "foo 1.0.1"
    end
  end

  it "warns when dropping the other constraints of a compound requirement" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", ">= 1.0", "< 2.0"
    G

    bundle "bump foo"

    expect(err).to include("Rewriting `>= 1.0, < 2.0` as `>= 2.0`, since the other constraints cannot be preserved")
    expect(bundled_app_gemfile.read).to match(/gem "foo", ">= 2\.0"\n/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "rewrites parenthesized declarations spanning several lines" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem(
        "foo",
        "~> 1.0"
      )
    G

    bundle "bump foo"

    expect(bundled_app_gemfile.read).to match(/gem\(\n  "foo",\n  "~> 2\.0"\n\)/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "rewrites single quoted parenthesized declarations" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem('foo', '~> 1.0')
    G

    bundle "bump foo"

    expect(bundled_app_gemfile.read).to match(/gem\('foo', "~> 2\.0"\)/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "rewrites every declaration of the gem" do
    install_gemfile <<-G
      source "https://gem.repo2"
      if ENV["BUNDLE_BUMP_UNSET"]
        gem "foo", "~> 1.0", require: false
      else
        gem "foo", "~> 1.0"
      end
    G

    bundle "bump foo"

    expect(bundled_app_gemfile.read.scan(/gem "foo", "~> 2\.0"/).size).to eq(2)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "rewrites declarations in evaluated Gemfiles" do
    create_file "Gemfile.extra", <<-G
      gem "foo", "~> 1.0"
    G

    install_gemfile <<-G
      source "https://gem.repo2"
      eval_gemfile "Gemfile.extra"
    G

    bundle "bump foo"

    expect(bundled_app("Gemfile.extra").read).to match(/gem "foo", "~> 2\.0"/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "rewrites gems.rb" do
    FileUtils.rm_f([bundled_app_gemfile, bundled_app_lock])
    create_file "gems.rb", <<-G
      source "https://gem.repo2"
      gem "foo", "~> 1.0"
    G
    bundle :install

    bundle "bump foo"

    expect(bundled_app("gems.rb").read).to match(/gem "foo", "~> 2\.0"/)
    expect(bundled_app("gems.locked").read).to include("foo (2.0)")
  end

  it "fails without touching the Gemfile when the declaration cannot be found" do
    install_gemfile <<-G
      source "https://gem.repo2"
      name = "foo"
      gem name, "~> 1.0"
    G

    bundle "bump foo", raise_on_error: false

    expect(err).to include("Could not find a `gem` declaration for foo to rewrite")
    expect(bundled_app_gemfile.read).to match(/gem name, "~> 1\.0"/)
    expect(bundled_app_lock.read).to include("foo (1.0.1)")
  end

  it "accepts -v as an alias of --version" do
    bundle "bump foo -v 1.0"

    expect(bundled_app_gemfile.read).to match(/gem "foo", "= 1\.0"/)
    expect(the_bundle).to include_gems "foo 1.0"
  end

  it "applies --version to every matched gem" do
    update_repo2 do
      build_gem "myrake", "13.1.0"
      build_gem "myrake-compiler", "1.2.0"
    end

    bundle "bump myrake myrake-compiler --version '>= 1.0'"

    expect(bundled_app_gemfile.read).to match(/gem "myrake", ">= 1\.0"/)
    expect(bundled_app_gemfile.read).to match(/gem "myrake-compiler", ">= 1\.0"/)
    expect(the_bundle).to include_gems "myrake 13.1.0", "myrake-compiler 1.2.0"
  end

  it "rejects combining --all with --version" do
    bundle "bump --all --version 1.0", raise_on_error: false

    expect(err).to include("Cannot combine --all with --version")
  end

  it "rejects conflicting pins for the same gem" do
    bundle "bump foo@1.0 'f*@2.0'", raise_on_error: false

    expect(err).to include('Conflicting version pins for foo: "= 1.0" and "= 2.0"')
    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 1\.0"/)
  end

  it "accepts the same pin given twice" do
    bundle "bump foo@1.0 'f*@1.0'"

    expect(bundled_app_gemfile.read).to match(/gem "foo", "= 1\.0"/)
  end

  it "reports when none of the selected gems are in the group" do
    bundle "bump foo --group development", raise_on_error: false

    expect(err).to include("None of the selected gems are in group(s) development")
  end

  it "only prints warnings and errors with --quiet" do
    bundle "bump foo --quiet"

    expect(out).to be_empty
    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0"/)
  end

  it "requires the bundle to be installed" do
    FileUtils.rm_f(bundled_app_lock)

    bundle "bump foo", raise_on_error: false

    expect(err).to include("This Bundle hasn't been installed yet")
    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 1\.0"/)
  end

  it "rejects combining operator flags" do
    bundle "bump foo --exact --tilde", raise_on_error: false

    expect(err).to include("Provide only one of --exact, --tilde, --gte, --lte.")
  end

  it "treats a leading or trailing @ as part of the gem name" do
    bundle "bump foo@", raise_on_error: false
    expect(err).to include("Could not find gem 'foo@'")

    bundle "bump @foo", raise_on_error: false
    expect(err).to include("Could not find gem '@foo'")
  end

  it "rejects empty version pins" do
    bundle "bump 'foo@ , '", raise_on_error: false

    expect(err).to include(%(Invalid version pin " , " for gem 'foo'.))
  end

  it "does not leave the --patch level when the newest patch does not resolve" do
    update_repo2 do
      build_gem "foo", "1.0.2" do |s|
        s.required_ruby_version = "> 99"
      end
      build_gem "foo", "1.1.0"
    end

    bundle "bump foo --patch"

    expect(out).to include("Bundle up to date!")
    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 1\.0"/)
  end

  it "keeps dependencies inside the level when installing with --patch --strict" do
    build_repo2 do
      build_gem "baz", %w[1.0.0 1.0.1 1.1.0]
      build_gem "qux", "1.0.1" do |s|
        s.add_dependency "baz", "= 1.0.0"
      end
      build_gem "qux", "1.0.2" do |s|
        s.add_dependency "baz", ">= 1.0"
      end
    end

    install_gemfile <<-G
      source "https://gem.repo2"
      gem "qux", "= 1.0.1"
    G

    bundle "bump qux --patch --strict"

    expect(bundled_app_gemfile.read).to match(/gem "qux", "= 1\.0\.2"/)
    expect(the_bundle).to include_gems "qux 1.0.2", "baz 1.0.1"
  end

  it "updates the gem cache" do
    bundle :cache

    bundle "bump foo"

    expect(cached_gem("foo-2.0")).to exist
  end

  it "cleans up the old versions when clean is configured" do
    bundle "config set --local path vendor/bundle"
    bundle "config set --local clean true"
    bundle :install

    bundle "bump foo"

    expect(vendored_gems("gems/foo-2.0")).to exist
    expect(vendored_gems("gems/foo-1.0.1")).not_to exist
  end

  it "prints post-install messages and funding requests" do
    update_repo2 do
      build_gem "foo", "2.1" do |s|
        s.post_install_message = "Foo's post install message"
        s.metadata = { "funding_uri" => "https://example.com/foo/funding" }
      end
    end

    bundle "bump foo"

    expect(out).to include("Post-install message from foo:")
    expect(out).to include("Foo's post install message")
    expect(out).to include("1 installed gem you directly depend on is looking for funding.")
  end

  it "says which groups were left out" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", "~> 1.0"
      gem "myrake", "~> 13.0", group: :development
    G
    bundle "config set --local without development"

    bundle "bump foo"

    expect(out).to include("Gems in the group 'development' were not updated.")
  end

  it "leaves the Gemfile alone when the update is declined interactively" do
    bundle "bump foo --interactive" do |input, _, _|
      input.puts "n"
    end

    expect(out).to include("Nothing to update.")
    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 1\.0"/)
    expect(the_bundle).to include_gems "foo 1.0.1"
  end
end
