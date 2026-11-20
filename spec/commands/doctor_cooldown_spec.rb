# frozen_string_literal: true

RSpec.describe "bundle doctor cooldown" do
  before do
    now = Time.now.utc
    build_repo3 do
      build_gem "ripe_gem", "1.0.0" do |s|
        s.date = now - (30 * 86_400)
      end
      build_gem "ripe_gem", "2.0.0" do |s|
        s.date = now - (1 * 86_400)
      end

      build_gem "almost_ripe", "1.0.0" do |s|
        s.date = now - (6 * 86_400)
      end

      # the generic build is outside the window, but a platform-specific
      # build of the same version was pushed inside it
      build_gem "late_platform", "2.0.0" do |s|
        s.date = now - (30 * 86_400)
      end
      build_gem "late_platform", "2.0.0" do |s|
        s.platform = "x86_64-linux"
        s.date = now - (1 * 86_400)
      end
    end
  end

  it "fails and lists the locked gems published inside the cooldown window" do
    gemfile <<-G
      source "https://gem.repo3"
      gem "ripe_gem"
    G

    bundle "lock", artifice: "compact_index_v2"
    expect(lockfile).to include("ripe_gem (2.0.0)")

    bundle "doctor cooldown --cooldown 7", artifice: "compact_index_v2", raise_on_error: false

    expect(exitstatus).to eq(1)
    expect(err).to include <<~E.strip
      The following locked gems are inside the cooldown window:
        * ripe_gem 2.0.0 (in cooldown for 6 more days)
    E
  end

  it "succeeds when every locked gem is outside the cooldown window" do
    gemfile <<-G
      source "https://gem.repo3"
      gem "ripe_gem", "1.0.0"
    G

    bundle "lock", artifice: "compact_index_v2"

    bundle "doctor cooldown --cooldown 7", artifice: "compact_index_v2"

    expect(out).to include("No locked gems are inside the cooldown window")
  end

  it "applies the cooldown declared on a source in the Gemfile" do
    gemfile <<-G
      source "https://gem.repo3"
      gem "ripe_gem"
    G

    bundle "lock", artifice: "compact_index_v2"

    gemfile <<-G
      source "https://gem.repo3", cooldown: 7
      gem "ripe_gem"
    G

    bundle "doctor cooldown", artifice: "compact_index_v2", raise_on_error: false

    expect(exitstatus).to eq(1)
    expect(err).to include("ripe_gem 2.0.0 (in cooldown for 6 more days)")
  end

  it "applies the cooldown from the configuration" do
    gemfile <<-G
      source "https://gem.repo3"
      gem "ripe_gem"
    G

    bundle "lock", artifice: "compact_index_v2"

    bundle "doctor cooldown", env: { "BUNDLE_COOLDOWN" => "7" }, artifice: "compact_index_v2", raise_on_error: false

    expect(exitstatus).to eq(1)
    expect(err).to include("ripe_gem 2.0.0 (in cooldown for 6 more days)")
  end

  it "uses the singular form when one cooldown day remains" do
    gemfile <<-G
      source "https://gem.repo3"
      gem "almost_ripe"
    G

    bundle "lock", artifice: "compact_index_v2"

    bundle "doctor cooldown --cooldown 7", artifice: "compact_index_v2", raise_on_error: false

    expect(err).to include("almost_ripe 1.0.0 (in cooldown for 1 more day)")
  end

  it "counts a platform-specific build of a locked version pushed inside the window" do
    gemfile <<-G
      source "https://gem.repo3"
      gem "late_platform"
    G

    lockfile <<~L
      GEM
        remote: https://gem.repo3/
        specs:
          late_platform (2.0.0)

      PLATFORMS
        ruby

      DEPENDENCIES
        late_platform

      BUNDLED WITH
         #{Bundler::VERSION}
    L

    bundle "doctor cooldown --cooldown 7", artifice: "compact_index_v2", raise_on_error: false

    expect(exitstatus).to eq(1)
    expect(err).to include("late_platform 2.0.0 (in cooldown for 6 more days)")
  end

  it "checks the lockfile as written and leaves it untouched" do
    # almost_ripe is missing from the lockfile and every version of it is
    # inside the window, so re-resolving instead of reading the lockfile
    # would fail the resolution
    gemfile <<-G
      source "https://gem.repo3"
      gem "ripe_gem"
      gem "almost_ripe"
    G

    lockfile <<~L
      GEM
        remote: https://gem.repo3/
        specs:
          ripe_gem (2.0.0)

      PLATFORMS
        ruby

      DEPENDENCIES
        ripe_gem

      BUNDLED WITH
         #{Bundler::VERSION}
    L

    expect do
      bundle "doctor cooldown --cooldown 7", artifice: "compact_index_v2", raise_on_error: false
    end.not_to change { lockfile }

    expect(out).not_to include("Resolving dependencies")
    expect(err).to include <<~E.strip
      The following locked gems are inside the cooldown window:
        * ripe_gem 2.0.0 (in cooldown for 6 more days)
    E
    expect(err).not_to include("almost_ripe")
  end

  it "skips gems that do not come from a gem server" do
    build_lib "local_gem", "1.0", path: lib_path("local_gem")

    gemfile <<-G
      source "https://gem.repo3"
      gem "ripe_gem", "1.0.0"
      gem "local_gem", path: "#{lib_path("local_gem")}"
    G

    bundle "lock", artifice: "compact_index_v2"

    bundle "doctor cooldown --cooldown 7", artifice: "compact_index_v2"

    expect(out).to include("No locked gems are inside the cooldown window")
    expect(err).not_to include("local_gem")
  end

  it "has nothing to check and fetches nothing when no cooldown is configured" do
    gemfile <<-G
      source "https://gem.repo3"
      gem "ripe_gem"
    G

    bundle "lock", artifice: "compact_index_v2"

    bundle "doctor cooldown", artifice: "compact_index_v2"

    expect(out).to include("No cooldown applies to the locked gems, so there is nothing to check")
    expect(out).not_to include("Fetching gem metadata")
  end

  it "lets --cooldown 0 bypass a configured cooldown" do
    gemfile <<-G
      source "https://gem.repo3", cooldown: 7
      gem "ripe_gem"
    G

    lockfile <<~L
      GEM
        remote: https://gem.repo3/
        specs:
          ripe_gem (2.0.0)

      PLATFORMS
        #{lockfile_platforms}

      DEPENDENCIES
        ripe_gem

      BUNDLED WITH
         #{Bundler::VERSION}
    L

    bundle "doctor cooldown --cooldown 0", artifice: "compact_index_v2"

    expect(out).to include("No cooldown applies to the locked gems, so there is nothing to check")
  end

  it "warns about locked gems whose source does not provide publish times" do
    gemfile <<-G
      source "https://gem.repo3"
      gem "ripe_gem"
    G

    bundle "lock", artifice: "compact_index"

    bundle "doctor cooldown --cooldown 7", artifice: "compact_index"

    expect(err).to include <<~E.strip
      Could not find a publish time for the following locked gems, so the cooldown was not checked for them:
        * ripe_gem 2.0.0
    E
    expect(out).to include("No locked gems are inside the cooldown window")
  end

  it "rejects a negative --cooldown value" do
    gemfile <<-G
      source "https://gem.repo3"
      gem "ripe_gem"
    G

    bundle "lock", artifice: "compact_index_v2"

    bundle "doctor cooldown --cooldown=-7", artifice: "compact_index_v2", raise_on_error: false

    expect(err).to match(/non-negative integer/)
  end

  it "fails when there is no lockfile" do
    gemfile <<-G
      source "https://gem.repo3"
      gem "ripe_gem"
    G

    bundle "doctor cooldown --cooldown 7", artifice: "compact_index_v2", raise_on_error: false

    expect(exitstatus).to eq(22)
    expect(err).to include("There is no Gemfile.lock to check. Run `bundle lock` to create one.")
  end
end
