# frozen_string_literal: true

require "tmpdir"
require "fileutils"
require "bundler"
require_relative "../spec/support/build_metadata"
require_relative "rubygems/helper"

class BuildMetadataGeneratorTest < Test::Unit::TestCase
  def test_write_build_metadata_stamps_the_given_built_at
    with_build_metadata_copy do |dir, file|
      Spec::BuildMetadata.write_build_metadata(dir: dir, built_at: "2100-01-01")

      assert_include File.read(file), %(@built_at = "2100-01-01")
    end
  end

  def test_write_build_metadata_leaves_built_at_unset_when_not_released
    with_build_metadata_copy do |dir, file|
      Spec::BuildMetadata.write_build_metadata(dir: dir, built_at: nil)

      assert_include File.read(file), "@built_at = nil"
    end
  end

  def test_write_build_metadata_defaults_to_today_in_the_release_date_format
    with_build_metadata_copy do |dir, file|
      Time.stub :now, Time.new(2020, 1, 1) do
        Spec::BuildMetadata.write_build_metadata(dir: dir)
      end

      assert_include File.read(file), %(@built_at = "2020-01-01")
    end
  end

  private

  def with_build_metadata_copy
    Dir.mktmpdir do |dir|
      file = File.join(dir, "lib/bundler/build_metadata.rb")
      FileUtils.mkdir_p File.dirname(file)
      FileUtils.cp Spec::BuildMetadata.source_root.join("lib/bundler/build_metadata.rb"), file

      Spec::BuildMetadata.stub(:git_commit_sha, "abc1234") do
        yield dir, file
      end
    end
  end
end
