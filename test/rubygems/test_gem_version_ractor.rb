# frozen_string_literal: true

require_relative "helper"

class TestGemVersionRactor < Gem::TestCase
  unless method_defined?(:assert_ractor)
    require "core_assertions"
    include Test::Unit::CoreAssertions
  end

  def setup
    super
    pend "Ruby::Box ignores $VERBOSE=, so assert_ractor cannot keep the Ractor experimental warning out of the child stderr (https://bugs.ruby-lang.org/issues/22282)" if ruby_box_enabled?
  end

  SETUP = <<~RUBY
    # Remove this after Ruby 4.0 or updating core_assertions.rb at Ruby 3.4.
    class Ractor; alias value take unless method_defined?(:value); end
  RUBY

  def test_new_in_ractor
    assert_ractor(SETUP + <<~RUBY, require: "rubygems/version")
      version = Ractor.new { Gem::Version.new("1.2.3").to_s }.value

      assert_equal "1.2.3", version
    RUBY
  end

  def test_create_in_ractor
    assert_ractor(SETUP + <<~RUBY, require: "rubygems/version")
      comparison = Ractor.new { Gem::Version.create("1.2.3") <=> Gem::Version.create("1.10") }.value

      assert_equal(-1, comparison)
    RUBY
  end

  def test_bump_in_ractor
    assert_ractor(SETUP + <<~RUBY, require: "rubygems/version")
      bumped = Ractor.new(Gem::Version.new("5.3.1.b.2")) {|version| version.bump.to_s }.value

      assert_equal "5.4", bumped
    RUBY
  end

  def test_release_in_ractor
    assert_ractor(SETUP + <<~RUBY, require: "rubygems/version")
      released = Ractor.new(Gem::Version.new("1.2.0.a")) {|version| version.release.to_s }.value

      assert_equal "1.2.0", released
    RUBY
  end
end unless RUBY_PLATFORM.match?(/mingw|mswin/)
