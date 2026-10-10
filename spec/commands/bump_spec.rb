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
    expect(bundled_app_gemfile.read).to match(/gem "myrake", "~> 13\.1\.0"/)
    expect(the_bundle).to include_gems "myrake 13.1.0"
    expect(the_bundle).to include_gems "foo 1.0.1"
  end

  it "pins to an explicit version with gem@version" do
    bundle "bump foo@1.0"

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

    expect(out).to include("Update foo from 1.0.1 to 2.0? (Y/n)")
    expect(out).to include("Bundle bumped!")
    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0"/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "shows the requirement in the prompt when confirming a compound pin" do
    bundle "bump 'foo@> 1.0, < 2.0' --interactive"

    expect(out).to include("Update foo from 1.0.1 to > 1.0, < 2.0? (Y/n)")
    expect(bundled_app_gemfile.read).to match(/gem "foo", "> 1\.0", "< 2\.0"/)
    expect(the_bundle).to include_gems "foo 1.0.1"
  end

  it "restores the Gemfile when the install fails" do
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

    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0", require: false\s+# keep this/)
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

    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0", require: false\s+# keep this/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "preserves a comment on the last line of a multi-line declaration" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", "~> 1.0",
        require: false # keep this
    G

    bundle "bump foo"

    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0", require: false\s+# keep this/)
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

    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0", require: false\s+# first # second # third/)
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
end
