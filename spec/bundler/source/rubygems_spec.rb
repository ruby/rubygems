# frozen_string_literal: true

RSpec.describe Bundler::Source::Rubygems do
  before do
    allow(Bundler).to receive(:root) { Pathname.new("root") }
  end

  describe "caches" do
    it "includes Bundler.app_cache" do
      expect(subject.caches).to include(Bundler.app_cache)
    end

    it "includes GEM_PATH entries" do
      Gem.path.each do |path|
        expect(subject.caches).to include(File.expand_path("#{path}/cache"))
      end
    end

    it "is an array of strings or pathnames" do
      subject.caches.each do |cache|
        expect([String, Pathname]).to include(cache.class)
      end
    end
  end

  describe "#add_remote" do
    context "when the source is an HTTP(s) URI with no host" do
      it "raises error" do
        expect { subject.add_remote("https:rubygems.org") }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#add_override_remote" do
    it "normalizes and stores the URI" do
      subject.add_override_remote("https://build-farm.example.com")
      expect(subject.override_remotes).to eq [Gem::URI("https://build-farm.example.com/")]
    end

    it "prepends new override remotes" do
      subject.add_override_remote("https://first.example.com")
      subject.add_override_remote("https://second.example.com")
      expect(subject.override_remotes).to eq [
        Gem::URI("https://second.example.com/"),
        Gem::URI("https://first.example.com/"),
      ]
    end

    it "does not add duplicates" do
      subject.add_override_remote("https://build-farm.example.com")
      subject.add_override_remote("https://build-farm.example.com")
      expect(subject.override_remotes.size).to eq 1
    end

    context "when the source is an HTTP(s) URI with no host" do
      it "raises error" do
        expect { subject.add_override_remote("https:build-farm.example.com") }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#no_remotes?" do
    context "when no remote provided" do
      it "returns a truthy value" do
        expect(described_class.new("remotes" => []).no_remotes?).to be_truthy
      end
    end

    context "when a remote provided" do
      it "returns a falsey value" do
        expect(described_class.new("remotes" => ["https://rubygems.org"]).no_remotes?).to be_falsey
      end
    end
  end

  describe "#clear_cache" do
    it "invalidates memoized indexes so subsequent reads rebuild them" do
      source = described_class.new

      first_specs = source.specs
      first_installed = source.send(:installed_specs)
      first_default = source.send(:default_specs)
      first_cached = source.send(:cached_specs)

      expect(source.specs).to equal(first_specs)
      expect(source.send(:installed_specs)).to equal(first_installed)
      expect(source.send(:default_specs)).to equal(first_default)
      expect(source.send(:cached_specs)).to equal(first_cached)

      source.clear_cache

      expect(source.specs).not_to equal(first_specs)
      expect(source.send(:installed_specs)).not_to equal(first_installed)
      expect(source.send(:default_specs)).not_to equal(first_default)
      expect(source.send(:cached_specs)).not_to equal(first_cached)
    end

    it "reflects newly-discovered installed gems after clear_cache" do
      source = described_class.new
      foo = Gem::Specification.new("foo", "1.0.0")
      bar = Gem::Specification.new("bar", "1.0.0")

      allow(Bundler.rubygems).to receive(:installed_specs).and_return([foo])
      expect(source.send(:installed_specs).search("bar")).to be_empty

      allow(Bundler.rubygems).to receive(:installed_specs).and_return([foo, bar])
      expect(source.send(:installed_specs).search("bar")).to be_empty

      source.clear_cache

      expect(source.send(:installed_specs).search("bar")).not_to be_empty
    end
  end

  describe "override remotes in initialize" do
    it "stores override remotes from options" do
      source = described_class.new(
        "remotes" => ["https://rubygems.org"],
        "overrides" => ["https://build-farm.example.com"]
      )
      expect(source.override_remotes).to eq [Gem::URI("https://build-farm.example.com/")]
    end

    it "handles multiple override remotes" do
      source = described_class.new(
        "remotes" => ["https://rubygems.org"],
        "overrides" => ["https://first.example.com", "https://second.example.com"]
      )
      expect(source.override_remotes.size).to eq 2
    end

    it "defaults to empty override remotes" do
      source = described_class.new("remotes" => ["https://rubygems.org"])
      expect(source.override_remotes).to eq []
    end
  end

  describe "#eql?" do
    it "considers sources with different override remotes as not equal" do
      without_overrides = described_class.new("remotes" => ["https://rubygems.org"])
      with_overrides = described_class.new(
        "remotes" => ["https://rubygems.org"],
        "overrides" => ["https://build-farm.example.com"]
      )
      expect(without_overrides).not_to eql(with_overrides)
    end

    it "considers sources with same remotes and override remotes as equal" do
      source_a = described_class.new(
        "remotes" => ["https://rubygems.org"],
        "overrides" => ["https://build-farm.example.com"]
      )
      source_b = described_class.new(
        "remotes" => ["https://rubygems.org"],
        "overrides" => ["https://build-farm.example.com"]
      )
      expect(source_a).to eql(source_b)
    end
  end

  describe "#hash" do
    it "differs for sources with different override remotes" do
      without_overrides = described_class.new("remotes" => ["https://rubygems.org"])
      with_overrides = described_class.new(
        "remotes" => ["https://rubygems.org"],
        "overrides" => ["https://build-farm.example.com"]
      )
      expect(without_overrides.hash).not_to eq(with_overrides.hash)
    end
  end

  describe "#to_lock" do
    it "includes override lines" do
      source = described_class.new(
        "remotes" => ["https://rubygems.org"],
        "overrides" => ["https://build-farm.example.com"]
      )
      expected = <<~L
        GEM
          remote: https://rubygems.org/
          override: https://build-farm.example.com/
          specs:
      L
      expect(source.to_lock).to eq(expected)
    end

    it "includes multiple override lines" do
      source = described_class.new(
        "remotes" => ["https://rubygems.org"],
        "overrides" => ["https://first.example.com", "https://second.example.com"]
      )
      lock = source.to_lock
      expect(lock).to include("override: https://first.example.com/")
      expect(lock).to include("override: https://second.example.com/")
    end

    it "omits override lines when no override remotes" do
      source = described_class.new("remotes" => ["https://rubygems.org"])
      expect(source.to_lock).not_to include("override:")
    end
  end

  describe ".from_lock" do
    it "restores override remotes from lockfile options" do
      source = described_class.from_lock(
        "remote" => "https://rubygems.org/",
        "override" => "https://build-farm.example.com/"
      )
      expect(source.override_remotes).to eq [Gem::URI("https://build-farm.example.com/")]
    end

    it "restores multiple override remotes from lockfile options" do
      source = described_class.from_lock(
        "remote" => "https://rubygems.org/",
        "override" => ["https://first.example.com/", "https://second.example.com/"]
      )
      expect(source.override_remotes.size).to eq 2
    end

    it "handles missing override key" do
      source = described_class.from_lock("remote" => "https://rubygems.org/")
      expect(source.override_remotes).to eq []
    end
  end

  describe "to_lock/from_lock round-trip" do
    it "preserves override remotes" do
      original = described_class.new(
        "remotes" => ["https://rubygems.org"],
        "overrides" => ["https://build-farm.example.com"]
      )

      # Simulate lockfile parser: parse the to_lock output
      lock_output = original.to_lock
      opts = {}
      lock_output.each_line do |line|
        next unless line =~ /^\s+([a-z]+): (.*)$/i
        key = $1
        value = $2
        if opts[key]
          opts[key] = Array(opts[key])
          opts[key] << value
        else
          opts[key] = value
        end
      end

      restored = described_class.from_lock(opts)
      expect(restored.remotes.map(&:to_s)).to eq(original.remotes.map(&:to_s))
      expect(restored.override_remotes.map(&:to_s)).to eq(original.override_remotes.map(&:to_s))
    end
  end

  describe "#fetch_override_specs" do
    let(:source) do
      described_class.new(
        "remotes" => ["https://rubygems.org"],
        "overrides" => ["https://build-farm.example.com"]
      )
    end

    let(:override_uri) { Gem::URI("https://build-farm.example.com/") }

    def stub_override_fetcher(specs)
      override_index = Bundler::Index.new
      Array(specs).each {|s| override_index << s }
      fetcher = double(Bundler::Fetcher, uri: override_uri)
      allow(fetcher).to receive(:specs_with_retry).and_return(override_index)
      allow(source).to receive(:override_fetchers).and_return([fetcher])
      allow(source).to receive(:dependency_names).and_return([])
    end

    it "raises GemfileError when override provides a gem absent from primary" do
      override_spec = Gem::Specification.new("missing-from-primary", "1.0.0")
      stub_override_fetcher(override_spec)

      primary_idx = Bundler::Index.new

      expect do
        source.send(:fetch_override_specs, primary_idx)
      end.to raise_error(Bundler::GemfileError, /missing-from-primary/)
    end

    it "skips override specs whose version does not match the primary source" do
      primary_spec = Gem::Specification.new("json", "2.7.0")
      override_spec = Gem::Specification.new("json", "2.7.1")
      stub_override_fetcher(override_spec)

      primary_idx = Bundler::Index.new
      primary_idx << primary_spec

      expect do
        source.send(:fetch_override_specs, primary_idx)
      end.not_to raise_error

      expect(primary_idx.search(["json", "2.7.1"])).to be_empty
    end
  end

  describe "log debug information" do
    it "log the time spent downloading and installing a gem" do
      build_repo2 do
        build_gem "warning"
      end

      gemfile_content = <<~G
        source "https://gem.repo2"
        gem "warning"
      G

      stdout = install_gemfile(gemfile_content, env: { "DEBUG" => "1" })

      expect(stdout).to match(/Downloaded warning in: \d+\.\d+s/)
      expect(stdout).to match(/Installed warning in: \d+\.\d+s/)
    end
  end
end
