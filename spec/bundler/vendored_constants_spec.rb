# frozen_string_literal: true

RSpec.describe "deprecated aliases of RubyGems' vendored libraries" do
  def with_deprecation_warnings(enabled)
    original = Warning[:deprecated]
    Warning[:deprecated] = enabled
    yield
  ensure
    Warning[:deprecated] = original
  end

  {
    "bundler/vendored_uri" => :URI,
    "bundler/vendored_pub_grub" => :PubGrub,
    "bundler/vendored_securerandom" => :SecureRandom,
    "bundler/compact_index_client" => :CompactIndexClient,
    "bundler/yaml_serializer" => :YAMLSerializer,
  }.each do |path, name|
    describe "Bundler::#{name}" do
      before { require path }

      it "is an alias of Gem::#{name}" do
        expect(Bundler.const_defined?(name, false)).to be(true)
        expect(with_deprecation_warnings(false) { Bundler.const_get(name) }).to be(Gem.const_get(name))
      end

      it "warns when deprecation warnings are enabled" do
        expect { with_deprecation_warnings(true) { Bundler.const_get(name) } }.
          to output(/constant Bundler::#{name} is deprecated/).to_stderr
      end
    end
  end
end
