# frozen_string_literal: true

RSpec.describe Bundler::MatchPlatform do
  describe ".prefer_content_addressable" do
    it "prefers a widened address when its platform and prefix match" do
      platform = Gem::Platform.new("arm64-darwin")
      short = double(
        :short,
        platform: platform,
        content_address: "ab123456",
        matches_current_metadata?: true
      )
      widened = double(
        :widened,
        platform: platform,
        content_address: "ab1234567890",
        matches_current_metadata?: true
      )

      matching = described_class.prefer_content_addressable([short, widened])

      expect(matching).to contain_exactly(widened)
    end

    it "does not replace a short address when the widened address has a different platform" do
      short = double(
        :short,
        platform: Gem::Platform.new("arm64-darwin-27"),
        content_address: "ab123456",
        matches_current_metadata?: true
      )
      widened = double(
        :widened,
        platform: Gem::Platform.new("arm64-darwin"),
        content_address: "ab1234567890",
        matches_current_metadata?: true
      )

      matching = described_class.prefer_content_addressable([short, widened])

      expect(matching).to contain_exactly(short, widened)
    end
  end
end
