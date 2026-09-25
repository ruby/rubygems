# frozen_string_literal: true

require_relative "helper"
require "rubygems"

begin
  require "rubygems/package_task"
rescue LoadError => e
  raise unless e.path == "rake/packagetask"
end

class TestGemPackageTask < Gem::TestCase
  def test_gem_package
    original_rake_fileutils_verbosity = RakeFileUtils.verbose_flag
    RakeFileUtils.verbose_flag = false

    gem = Gem::Specification.new do |g|
      g.name = "pkgr"
      g.version = "1.2.3"

      g.authors = %w[author]
      g.files = %w[x]
      g.summary = "summary"
    end

    Rake.application = Rake::Application.new

    pkg = Gem::PackageTask.new(gem) do |p|
      p.package_files << "y"
    end

    assert_equal %w[x y], pkg.package_files

    Dir.chdir @tempdir do
      FileUtils.touch "x"
      FileUtils.touch "y"

      Rake.application["package"].invoke

      assert_path_exist "pkg/pkgr-1.2.3.gem"
    end
  ensure
    RakeFileUtils.verbose_flag = original_rake_fileutils_verbosity
  end

  def test_passes_content_addressable_to_build_and_moves_filename_returned_by_build
    original_rake_fileutils_verbosity = RakeFileUtils.verbose_flag
    RakeFileUtils.verbose_flag = false

    gem = Gem::Specification.new do |g|
      g.name = "pkgr"
      g.version = "1.2.3"
      g.platform = "arm64-darwin"
      g.required_ruby_version = "~> 3.4.0"

      g.authors = %w[author]
      g.files = %w[x]
      g.summary = "summary"
    end

    Rake.application = Rake::Application.new

    pkg = Gem::PackageTask.new(gem) do |p|
      p.package_files << "y"
      p.content_addressable = true
    end

    assert_equal %w[x y], pkg.package_files

    Dir.chdir @tempdir do
      FileUtils.touch "x"
      FileUtils.touch "y"

      built_gem_file = "pkgr-1.2.3-01234567.gem"

      Gem::Package.stub :build, ->(_spec, _skip_validation, _strict_validation, _file_name, content_addressable) {
        FileUtils.touch built_gem_file
        assert content_addressable
        built_gem_file
      } do
        Rake.application["package"].invoke
      end

      built_files = Dir["pkg/pkgr-1.2.3-*.gem"]

      assert_equal 1, built_files.length
      assert_equal "pkg/pkgr-1.2.3-01234567.gem", built_files.first
      assert_path_not_exist "pkg/pkgr-1.2.3-arm64-darwin.gem"
      stamp_path = "pkg/pkgr-1.2.3-arm64-darwin-3.4.gem-built"

      assert_path_exist stamp_path
      # The stamp file should contain the path to the built gem file as a help to maintainers
      assert_equal File.join("pkg", built_gem_file), File.read(stamp_path)
    end
  ensure
    RakeFileUtils.verbose_flag = original_rake_fileutils_verbosity
  end

  def test_rebuilds_content_addressable_gem_when_stamp_points_to_missing_gem
    original_rake_fileutils_verbosity = RakeFileUtils.verbose_flag
    RakeFileUtils.verbose_flag = false

    gem = Gem::Specification.new do |g|
      g.name = "pkgr"
      g.version = "1.2.3"
      g.platform = "arm64-darwin"
      g.required_ruby_version = "~> 3.4.0"

      g.authors = %w[author]
      g.files = %w[x]
      g.summary = "summary"
    end

    Dir.chdir @tempdir do
      FileUtils.touch "x"
      FileUtils.mkdir_p "pkg"

      stamp_path = "pkg/pkgr-1.2.3-arm64-darwin-3.4.gem-built"
      missing_gem_path = "pkg/pkgr-1.2.3-deadbeef.gem"
      File.write stamp_path, missing_gem_path

      Rake.application = Rake::Application.new
      Gem::PackageTask.new(gem) do |package|
        package.content_addressable = true
      end

      assert_path_not_exist stamp_path

      built_gem_file = "pkgr-1.2.3-01234567.gem"
      Gem::Package.stub :build, ->(_spec, _skip_validation, _strict_validation, _file_name, content_addressable) {
        FileUtils.touch built_gem_file
        assert content_addressable
        built_gem_file
      } do
        Rake.application["package"].invoke
      end

      built_gem_path = File.join("pkg", built_gem_file)
      assert_path_exist built_gem_path
      assert_equal built_gem_path, File.read(stamp_path)
    end
  ensure
    RakeFileUtils.verbose_flag = original_rake_fileutils_verbosity
  end

  def test_gem_package_prints_to_stdout_by_default
    gem = Gem::Specification.new do |g|
      g.name = "pkgr"
      g.version = "1.2.3"

      g.authors = %w[author]
      g.files = %w[x]
      g.summary = "summary"
    end

    _, err = capture_output do
      Rake.application = Rake::Application.new

      pkg = Gem::PackageTask.new(gem) do |p|
        p.package_files << "y"
      end

      assert_equal %w[x y], pkg.package_files

      Dir.chdir @tempdir do
        FileUtils.touch "x"
        FileUtils.touch "y"

        Rake.application["package"].invoke
      end
    end

    assert_empty err
  end

  def test_gem_package_with_current_platform
    gem = Gem::Specification.new do |g|
      g.name = "pkgr"
      g.version = "1.2.3"
      g.files = Rake::FileList["x"].resolve
      g.platform = Gem::Platform::CURRENT
    end
    pkg = Gem::PackageTask.new(gem) do |p|
      p.package_files << "y"
    end
    assert_equal ["x", "y"], pkg.package_files
  end

  def test_gem_package_with_ruby_platform
    gem = Gem::Specification.new do |g|
      g.name = "pkgr"
      g.version = "1.2.3"
      g.files = Rake::FileList["x"].resolve
      g.platform = Gem::Platform::RUBY
    end
    pkg = Gem::PackageTask.new(gem) do |p|
      p.package_files << "y"
    end
    assert_equal ["x", "y"], pkg.package_files
  end

  def test_package_dir_path
    gem = Gem::Specification.new do |g|
      g.name = "nokogiri"
      g.version = "1.5.0"
      g.platform = "java"
    end

    pkg = Gem::PackageTask.new gem
    pkg.define

    assert_equal "pkg/nokogiri-1.5.0-java", pkg.package_dir_path
  end
end if defined?(Rake::PackageTask)
