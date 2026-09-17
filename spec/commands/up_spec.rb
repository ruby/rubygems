# frozen_string_literal: true

RSpec.describe "bundle up" do
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

    bundle "up myrake"

    expect(out).to include("Bundle up!")
    expect(bundled_app_gemfile.read).to match(/gem "myrake", "~> 13\.1\.0"/)
    expect(the_bundle).to include_gems "myrake 13.1.0"
    expect(the_bundle).to include_gems "foo 1.0.1"
  end

  it "pins to an explicit version with gem@version" do
    bundle "up foo@1.0"

    expect(out).to include("Bundle up!")
    expect(bundled_app_gemfile.read).to match(/gem "foo", "= 1\.0"/)
    expect(the_bundle).to include_gems "foo 1.0"
  end

  it "supports glob patterns" do
    update_repo2 do
      build_gem "myrake", "13.1.0"
      build_gem "myrake-compiler", "1.2.0"
    end

    bundle 'up "myrake*"'

    expect(out).to include("Bundle up!")
    expect(bundled_app_gemfile.read).to match(/gem "myrake", "~> 13\.1\.0"/)
    expect(bundled_app_gemfile.read).to match(/gem "myrake-compiler", "~> 1\.2\.0"/)
    expect(the_bundle).to include_gems "myrake 13.1.0", "myrake-compiler 1.2.0"
  end

  it "reports an error when no pattern matches" do
    bundle "up nosuchgem", raise_on_error: false

    expect(err).to include("Could not find gem 'nosuchgem'")
  end

  it "requires at least one pattern" do
    bundle "up", raise_on_error: false

    expect(err).to include("Please specify gems to update")
  end

  it "writes an exact requirement with --exact" do
    bundle "up foo --exact"

    expect(bundled_app_gemfile.read).to match(/gem "foo", "= 2\.0"/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "writes a pessimistic requirement with --tilde" do
    bundle "up foo --tilde"

    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0"/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "writes an optimistic requirement with --gte" do
    bundle "up foo --gte"

    expect(bundled_app_gemfile.read).to match(/gem "foo", ">= 2\.0"/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "writes a ceiling requirement with --lte" do
    bundle "up foo --lte"

    expect(bundled_app_gemfile.read).to match(/gem "foo", "<= 2\.0"/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "rejects combining --version with operator flags" do
    bundle "up foo --version='> 1.0' --exact", raise_on_error: false

    expect(err).to include("Provide only one of --version and --exact")
  end

  it "rejects combining gem@version pins with --version" do
    bundle "up foo@1.0 --version='> 1.0'", raise_on_error: false

    expect(err).to include("Cannot combine `gem@version` pins with --version")
  end

  it "rejects invalid version pins" do
    bundle "up foo@blah", raise_on_error: false

    expect(err).to include("Invalid version pin")
  end

  it "writes compound requirements from gem@version pins" do
    bundle 'up "foo@> 1.0, < 2.0"'

    expect(out).to include("Bundle up!")
    expect(bundled_app_gemfile.read).to match(/gem "foo", "> 1\.0", "< 2\.0"/)
    expect(the_bundle).to include_gems "foo 1.0.1"
  end

  it "writes compound requirements from --version" do
    bundle "up foo --version='> 1.0, < 2.0'"

    expect(out).to include("Bundle up!")
    expect(bundled_app_gemfile.read).to match(/gem "foo", "> 1\.0", "< 2\.0"/)
    expect(the_bundle).to include_gems "foo 1.0.1"
  end

  it "rewrites the requirement with --gte even when already at the latest version" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", "= 2.0"
    G

    bundle "up foo --gte"

    expect(out).to include('requirement updated to ">= 2.0"')
    expect(bundled_app_gemfile.read).to match(/gem "foo", ">= 2\.0"/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "stays quiet when the requirement already matches" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", ">= 2.0"
    G

    bundle "up foo --gte"

    expect(out).to include("Bundle up to date!")
    expect(bundled_app_gemfile.read).to match(/gem "foo", ">= 2\.0"/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "respects --patch --strict by leaving the gem alone" do
    bundle "up foo --patch --strict"

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

    bundle "up myrake foo --group development"

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

      bundle "up foo"

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

      bundle "up foo"

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

      bundle "up foo"

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

      bundle "up foo"

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

      bundle "up foo"

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

      bundle "up foo"

      expect(bundled_app_gemfile.read).to match(/gem "foo", "2\.0"/)
      expect(bundled_app_gemfile.read).not_to match(/gem "foo", "= 2\.0"/)
      expect(the_bundle).to include_gems "foo 2.0"
    end

    it "leaves an already latest bare version alone" do
      install_gemfile <<-G
        source "https://gem.repo2"
        gem "foo", "2.0"
      G

      bundle "up foo"

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

      bundle "up foo"

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

    bundle "up myrake"

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

      bundle "up foo --patch"

      expect(out).to include("Bundle up!")
      expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 1\.0\.2"/)
      expect(the_bundle).to include_gems "foo 1.0.2"
    end

    it "leaves a gem alone with --patch when nothing newer exists in its level" do
      update_repo2 do
        build_gem "foo", "1.1.0"
        build_gem "foo", "2.0"
      end

      bundle "up foo --patch"

      expect(out).to include("Bundle up to date!")
      expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 1\.0"/)
      expect(the_bundle).to include_gems "foo 1.0.1"
    end

    it "updates only within the current major version with --minor" do
      update_repo2 do
        build_gem "foo", "1.1.0"
        build_gem "foo", "2.0"
      end

      bundle "up foo --minor"

      expect(out).to include("Bundle up!")
      expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 1\.1\.0"/)
      expect(the_bundle).to include_gems "foo 1.1.0"
    end
  end

  it "accepts the default answer when --interactive cannot read from stdin" do
    bundle "up foo --interactive"

    expect(out).to include("Update foo from 1.0.1 to 2.0? (Y/n)")
    expect(out).to include("Bundle up!")
    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0"/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "shows the requirement in the prompt when confirming a compound pin" do
    bundle "up 'foo@> 1.0, < 2.0' --interactive"

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

    bundle "up foo@1.0", raise_on_error: false

    expect(err).to include("Could not find compatible versions")
    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0"/)
    expect(bundled_app_lock.read).to include("foo (2.0)")
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "does not rewrite the Gemfile when frozen mode is set" do
    bundle "config set --local frozen true"
    bundle "up foo", raise_on_error: false

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

    bundle "up foo"

    expect(err).to include("Bundler attempted to update foo but it comes from Bundler::Source::Path, skipping.")
    expect(out).to include("Bundle up to date!")
  end

  it "skips a gem from a git source with a warning" do
    build_git "foo", path: lib_path("foo")

    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", git: "#{lib_path("foo")}"
    G

    bundle "up foo"

    expect(err).to include("Bundler attempted to update foo but it comes from Bundler::Source::Git, skipping.")
    expect(out).to include("Bundle up to date!")
  end

  it "suggests similar gem names when no pattern matches" do
    bundle "up myrak", raise_on_error: false

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

    bundle "up foo"

    expect(bundled_app_gemfile.read).to match(/gem "foo",\n  "~> 2\.0",\n  require: false/)
    expect(the_bundle).to include_gems "foo 2.0"
  end

  it "preserves a trailing comment when rewriting" do
    install_gemfile <<-G
      source "https://gem.repo2"
      gem "foo", "~> 1.0" # keep this
    G

    bundle "up foo"

    expect(bundled_app_gemfile.read).to match(/gem "foo", "~> 2\.0".*# keep this/)
    expect(the_bundle).to include_gems "foo 2.0"
  end
end
