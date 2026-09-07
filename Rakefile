# frozen_string_literal: true

RakeFileUtils.verbose_flag = false

require "rubygems"
require "rubygems/package_task"
require "rake/testtask"

require_relative "spec/support/rubygems_ext"

desc "Setup Rubygems dev environment"
task setup: [:"dev:deps"] do
  Dir.glob("tool/bundler/*_gems.rb").each do |file|
    name = File.basename(file, ".rb")
    next if name == "dev_gems"
    Spec::Rubygems.dev_bundle "lock", gemfile: file
  end
end

desc "Update Rubygems dev environment"
task :update do
  Spec::Rubygems.dev_bundle "update", "--all"
  Dir.glob("tool/bundler/*_gems.rb").each do |file|
    name = File.basename(file, ".rb")
    next if name == "dev_gems"
    Spec::Rubygems.dev_bundle "lock", "--update", gemfile: file
  end
end

namespace :version do
  desc "Update the locked bundler version in dev environment"
  task :update_locked_bundler do |_, _args|
    stdout = Spec::Rubygems.dev_bundle "--version"
    version = stdout.split(" ").last
    ENV["SKIP_BUNDLER_CHECKSUM"] = "1"

    Dir.glob("{tool/bundler/*_gems.rb,spec/realworld/fixtures/*/Gemfile}").each do |file|
      Spec::Rubygems.dev_bundle("lock", "--update", "--bundler", version, gemfile: file)
    end
  end

  desc "Check locked bundler version is up to date"
  task check: :update_locked_bundler do
    Spec::Rubygems.check_source_control_changes(
      success_message: "Locked bundler version is in sync",
      error_message: "Please run `rake version:update_locked_bundler` and commit the result."
    )
  end
end

desc "Update specific development dependencies"
task :update_dev_dep do |_, args|
  Spec::Rubygems.dev_bundle "update", *args
end

desc "Update RSpec related gems"
task :update_rspec_deps do |_, _args|
  Spec::Rubygems.dev_bundle "update", "rspec-core", "rspec-expectations", "rspec-mocks"
  Spec::Rubygems.dev_bundle "lock", "--update", "rspec-core", "rspec-expectations", "rspec-mocks", gemfile: "tool/bundler/rubocop_gems.rb"
  Spec::Rubygems.dev_bundle "lock", "--update", "rspec-core", "rspec-expectations", "rspec-mocks", gemfile: "tool/bundler/standard_gems.rb"
end

desc "Setup git hooks"
task :git_hooks do
  sh "git config core.hooksPath .githooks"
end

Rake::TestTask.new do |t|
  t.ruby_opts = %w[-w]
  t.ruby_opts << "-rdevkit" if RbConfig::CONFIG["host_os"].include?("mingw")

  unless ENV["GEM_COMMAND"]
    coverage_setup = File.expand_path("test/rubygems/coverage_setup.rb", __dir__)
    t.ruby_opts.unshift("--disable-gems", "-r#{coverage_setup}")
  end

  t.libs << "test"
  t.test_files = FileList["test/**/test_*.rb"]
end

namespace "test" do
  desc "Run each test isolatedly by specifying the relative test file path"
  task "isolated" do
    FileList["test/**/{bundler_,}test_*.rb"].each do |file|
      sh Gem.ruby, "-Ilib:test", file
    end
  end

  desc "Run RubyGems tests using test-unit's process-based parallel runner"
  task "parallel" do
    sh File.expand_path("bin/test-unit", __dir__), "test", "--parallel=process"
  end
end

task default: [:test, :spec]

desc "Generate coverage report from collected results"
task "coverage:report" do
  resultset = File.join(__dir__, "coverage", ".resultset.json")
  next unless File.exist?(resultset)

  begin
    require "simplecov"
  rescue LoadError
    next
  end

  $stderr = File.open(File::NULL, "w")
  SimpleCov.collate Dir[resultset] do
    coverage_dir "coverage"
    skip "/test/"
    skip "/spec/"
    skip "/tool/"
    skip "/lib/rubygems/vendor/"
    skip "/lib/bundler/vendor/"
    skip "/tmp/"
    skip ".gemspec"

    group "RubyGems" do |src|
      src.filename.include?("/lib/rubygems/") || src.filename.end_with?("/lib/rubygems.rb")
    end
    group "Bundler" do |src|
      src.filename.include?("/lib/bundler/") || src.filename.end_with?("/lib/bundler.rb")
    end
  end
ensure
  $stderr = STDERR
end

spec = Gem::Specification.load(File.expand_path("rubygems-update.gemspec", __dir__))
v = spec.version

require "rdoc/task"

RDoc::Task.new rdoc: "docs", clobber_rdoc: "clobber_docs" do |doc|
  doc.main   = "README.md"
  doc.title  = "RubyGems #{v} API Documentation"

  rdoc_files = Rake::FileList.new %w[lib]
  rdoc_files.add %w[CHANGELOG.md LICENSE.txt MIT.txt CODE_OF_CONDUCT.md CONTRIBUTING.md
                    doc/MAINTAINERS.txt Manifest.txt doc/POLICIES.md README.md doc/UPGRADING.md
                    hide_lib_for_update/note.txt].map(&:freeze)

  doc.rdoc_files = rdoc_files

  doc.rdoc_dir = "rdoc"
end

namespace :vendor do
  desc "Download vendored gems to tmp"
  task :bundle do
    sh({ "BUNDLE_PATH" => "../../tmp/vendor", "BUNDLER_GEM_DEFAULT_DIR" => "../../tmp/vendor", "RUBYOPT" => "--disable-gems -r#{File.expand_path("spec/support/hax.rb", __dir__)} -Ilib" }, "bin/bundle", "install", "--gemfile=tool/bundler/vendor_gems.rb")
  end

  desc "Install patched vendored gems"
  task install: :bundle do
    sh({ "BUNDLE_GEMFILE" => "tool/bundler/vendor_gems.rb", "BUNDLE_PATH" => "../../tmp/vendor", "BUNDLER_GEM_DEFAULT_DIR" => "../../tmp/vendor", "RUBYOPT" => "-rpathname -r#{File.expand_path("spec/support/hax.rb", __dir__)} -Ilib" }, "bin/bundle", "exec", "tool/automatiek/vendor.rb")
  end

  desc "Check vendored gems are up to date"
  task check: :install do
    Spec::Rubygems.check_source_control_changes(
      success_message: "Vendored gems are in sync",
      error_message: "Vendored gems are out of sync. Please update the vendored lib patches."
    )
  end

  # Pinned upstream revision of rubygems/rubygems.org that the vendored
  # compact_index copy is generated from. Bump this (or pass COMPACT_INDEX_REF)
  # and re-run the task to refresh.
  COMPACT_INDEX_REF = "30703392778df8f2fb63d4cc1f45a64ffbeb7629"
  COMPACT_INDEX_FILES = %w[
    lib/compact_index.rb
    lib/compact_index/dependency.rb
    lib/compact_index/gem.rb
    lib/compact_index/gem_version.rb
    lib/compact_index/versions_file.rb
  ].freeze

  desc "Vendor spec-suite compact_index from rubygems.org (COMPACT_INDEX_REF to override ref)"
  task :compact_index do
    require "open-uri"
    require "fileutils"

    ref = ENV["COMPACT_INDEX_REF"] || COMPACT_INDEX_REF
    dest_root = File.expand_path("spec/support/vendor/compact_index", __dir__)

    COMPACT_INDEX_FILES.each do |path|
      url = "https://raw.githubusercontent.com/rubygems/rubygems.org/#{ref}/#{path}"
      contents = URI.parse(url).open(&:read).gsub("CompactIndex", "VendoredCompactIndex")

      target = File.join(dest_root, path)
      FileUtils.mkdir_p(File.dirname(target))
      File.write(target, contents)
    end

    puts "Vendored compact_index from rubygems.org@#{ref} into #{dest_root}"
  end

  desc "Check vendored compact_index is up to date"
  task compact_index_check: :compact_index do
    Spec::Rubygems.check_source_control_changes(
      success_message: "Vendored compact_index is in sync",
      error_message: "Vendored compact_index is out of sync. Run `rake vendor:compact_index`."
    )
  end
end

namespace :rubocop do
  desc "Setup gems necessary to lint Ruby code"
  task(:setup) do
    sh({ "RUBYOPT" => "-Ilib" }, "bin/bundle", "install", "--gemfile=tool/bundler/lint_gems.rb")
  end

  desc "Run rubocop. Pass positional arguments as Rake arguments, e.g. `rake 'rubocop:run[-a]'`"
  task :run do |_, args|
    sh "bin/rubocop", *args
  end
end

task rubocop: %w[rubocop:setup rubocop:run]

# --------------------------------------------------------------------
# Creating a release

task prerelease: %w[clobber install_release_dependencies bundler:build_metadata check_deprecations]
task postrelease: %w[upload guides:publish blog:publish bundler:build_metadata:clean]

desc "Check for deprecated methods with expired deprecation horizon"
task :check_deprecations do
  if v.segments[2] == 0
    sh("bin/rubocop -r ./tool/cops/deprecations --only Rubygems/Deprecations lib")
  else
    puts "Skipping deprecation checks since not releasing a major or minor version."
  end
end

desc "Install release dependencies"
task :install_release_dependencies do
  require_relative "tool/release"

  Release.install_dependencies!
end

desc "Prepare a release"
task :prepare_release, [:version] => [:install_release_dependencies] do |_t, opts|
  require_relative "tool/release"

  Release.new(opts[:version] || v.to_s).prepare!
end

desc "Install rubygems to local system"
task install: [:clear_package, :package] do
  sh "ruby -Ilib exe/gem install --no-document pkg/rubygems-update-#{v}.gem --backtrace && update_rubygems --no-document --backtrace"
end

desc "Clears previously built package"
task :clear_package do
  rm_rf "pkg"
end

desc "Generates the changelog for a specific target version"
task :generate_changelog, [:version] => [:install_release_dependencies] do |_t, opts|
  require_relative "tool/release"

  Release.new(opts[:version]).cut_changelog!
end

desc "Release rubygems-#{v}"
task release: :prerelease do
  Rake::Task["package"].invoke
  puts "Tagging v#{v}"
  sh "git", "tag", "v#{v}", noop: ENV["DRYRUN"]
  puts "Pushing v#{v} to origin"
  sh "git", "push", "origin", "v#{v}", noop: ENV["DRYRUN"]
  puts "Pushing rubygems-update-#{v} to RubyGems.org"
  sh "gem", "push", "pkg/rubygems-update-#{v}.gem", noop: ENV["DRYRUN"]
  Rake::Task["postrelease"].invoke
end

Gem::PackageTask.new(spec) {}

Rake::Task["package"].enhance ["pkg/rubygems-#{v}.tgz", "pkg/rubygems-#{v}.zip"]

file "pkg/rubygems-#{v}" => "pkg/rubygems-update-#{v}" do |t|
  require "find"

  dest_root = File.expand_path t.name

  cd t.source do
    Find.find "." do |file|
      dest = File.expand_path file, dest_root

      if File.directory? file
        mkdir_p dest
      else
        rm_f dest
        safe_ln file, dest
      end
    end
  end
end

file "pkg/rubygems-#{v}.zip" => "pkg/rubygems-#{v}" do
  cd "pkg" do
    if Gem.win_platform?
      sh "7z a rubygems-#{v}.zip rubygems-#{v}"
    else
      sh "zip -q -r rubygems-#{v}.zip rubygems-#{v}"
    end
  end
end

file "pkg/rubygems-#{v}.tgz" => "pkg/rubygems-#{v}" do
  cd "pkg" do
    tar_version = `tar --version`
    if tar_version.include?("bsdtar")
      # bsdtar, as used by at least FreeBSD and macOS, uses `--uname` and `--gname`.
      # COPYFILE_DISABLE prevents storing macOS extended attribute data in `._*` files inside the archive
      sh({ "COPYFILE_DISABLE" => "1" }, "tar -czf rubygems-#{v}.tgz --uname=rubygems:0 --gname=rubygems:0 rubygems-#{v}")
    else # If a third variant is added, change this line to: elsif tar_version =~ /GNU tar/
      # GNU Tar, as used by many Linux distros, uses `--owner` and `--group`.
      sh "tar -czf rubygems-#{v}.tgz --owner=rubygems:0 --group=rubygems:0 rubygems-#{v}"
    end
  end
end

desc "Upload the release to GitHub releases"
task :upload_to_github do
  require_relative "tool/release"

  Release.new(v.to_s).create_for_github!
end

desc "Upload release to S3"
task :upload_to_s3 do
  require "aws-sdk-s3"

  client = Aws::S3::Client.new(region: "us-west-2")
  transfer_manager = Aws::S3::TransferManager.new(client: client)

  %w[zip tgz].each do |ext|
    transfer_manager.upload_file(
      "pkg/rubygems-#{v}.#{ext}",
      bucket: "oregon.production.s3.rubygems.org",
      key: "rubygems/rubygems-#{v}.#{ext}",
      acl: "public-read"
    )
  end
end

desc "Upload release to rubygems.org"
task :upload do
  if ENV["DRYRUN"]
    puts "DRYRUN mode: skipping upload to GitHub and S3"
  else
    Rake::Task["check_release_preparations"].invoke
    Rake::Task["upload_to_github"].invoke
    Rake::Task["upload_to_s3"].invoke
  end
end

directory "tmp/guides.rubygems.org" do
  sh "git", "clone",
     "https://github.com/rubygems/guides.git",
     "tmp/guides.rubygems.org"
end

namespace "guides" do
  task "pull" => %w[tmp/guides.rubygems.org] do
    chdir "tmp/guides.rubygems.org" do
      sh "git", "pull"
    end
  end

  task "update" => %w[tmp/guides.rubygems.org] do
    rubygems_dir = Dir.pwd
    env = {
      "BUNDLE_GEMFILE" => nil,
      "BUNDLE_WITHOUT" => "site:jekyll_plugins",
      "RUBYOPT" => "--disable-gems -I#{File.join(rubygems_dir, "lib")}",
      "RUBYGEMS_DIR" => rubygems_dir,
    }

    chdir "tmp/guides.rubygems.org" do
      sh env, "bundle", "install"
      sh env, "bundle", "exec", "rake", "command_reference"
      sh env, "bundle", "exec", "rake", "spec_guide"

      # `bundle install` may rewrite the lockfile (BUNDLED WITH), which would
      # leave the checkout dirty and break future pulls
      sh "git", "checkout", "--", "Gemfile.lock"
    end
  end

  task "commit" => %w[tmp/guides.rubygems.org] do
    chdir "tmp/guides.rubygems.org" do
      sh "git", "add", "command-reference.md", "specification-reference.md", "command-reference"
      sh "git", "diff", "--cached", "--quiet"
    rescue StandardError
      sh "git", "commit", "-m", "Rebuild for RubyGems #{v}"
    end
  end

  task "push" => %w[tmp/guides.rubygems.org] do
    chdir "tmp/guides.rubygems.org" do
      if ENV["DRYRUN"]
        puts "DRYRUN mode: skipping push to guides repository"
      else
        sh "git", "push"
      end
    end
  end

  desc "Updates and publishes the guides for the just-released RubyGems"
  task "publish"

  task "publish" => %w[
    guides:pull
    guides:update
    guides:commit
    guides:push
  ]
end

directory "tmp/blog.rubygems.org" do
  sh "git", "clone",
    "https://github.com/rubygems/blog.git",
     "tmp/blog.rubygems.org"
end

namespace "blog" do
  date = Time.now.strftime "%Y-%m-%d"
  post_page = "_posts/#{date}-#{v}-released.md"
  checksums = ""

  task "checksums" => "package" do
    Dir["pkg/*{tgz,zip,gem}"].each do |file|
      digest = OpenSSL::Digest::SHA256.file(file).hexdigest
      basename = File.basename(file)

      checksums += "* #{basename}  \n"
      checksums += "  #{digest}\n"

      if ENV["DRYRUN"]
        puts "DRYRUN mode: skipping checksum verification for #{file}"
      else
        require "net/http"
        release_url = URI("https://rubygems.org/#{file.end_with?("gem") ? "gems" : "rubygems"}/#{basename}")
        response = Net::HTTP.get_response(release_url)

        if response.is_a?(Net::HTTPSuccess)
          released_digest = OpenSSL::Digest::SHA256.hexdigest(response.body)

          if digest != released_digest
            abort "Checksum of #{file} (#{digest}) doesn't match checksum of released package at #{release_url} (#{released_digest})"
          end
        elsif response.is_a?(Net::HTTPForbidden)
          abort "#{basename} has not been yet uploaded to rubygems.org"
        else
          abort "Error fetching released package to verify checksums: #{response}\n#{response.body}"
        end
      end
    end
  end

  task "pull" => %w[tmp/blog.rubygems.org] do
    chdir "tmp/blog.rubygems.org" do
      sh "git", "pull"
    end
  end

  path = File.join "tmp/blog.rubygems.org", post_page

  task "update" => [path]

  file path => "checksums" do
    name  = `git config --get user.name`.strip
    email = `git config --get user.email`.strip

    require_relative "tool/changelog"
    history = Changelog.for_release(v.to_s)

    require "tempfile"

    Tempfile.open "blog_post" do |io|
      io.write <<-ANNOUNCEMENT
---
title: #{v} Released
layout: post
author: #{name}
author_email: #{email}
---

RubyGems and Bundler #{v} include #{history.change_types_for_blog}.

To update to the latest RubyGems you can run:

    gem update --system [--pre]

To update to the latest Bundler you can run:

    gem install bundler [--pre]
    bundle update --bundler=#{v}

## Release Notes

#{history.release_notes_for_blog.join("\n")}

## Manual Installation

To install RubyGems by hand see the [Download RubyGems][download] page.

SHA256 Checksums:

#{checksums}

[download]: https://rubygems.org/pages/download

      ANNOUNCEMENT

      io.flush

      sh(ENV["EDITOR"] || "vim", io.path)

      FileUtils.cp io.path, path
    end
  end

  task "commit" => %w[tmp/blog.rubygems.org] do
    chdir "tmp/blog.rubygems.org" do
      sh "git", "add", post_page
      sh "git", "commit", post_page,
         "-m", "Added #{v} release announcement"
    end
  end

  task "push" => %w[tmp/blog.rubygems.org] do
    chdir "tmp/blog.rubygems.org" do
      if ENV["DRYRUN"]
        puts "DRYRUN mode: skipping push to blog repository"
      else
        sh "git", "push"
      end
    end
  end

  desc "Updates and publishes the blog for the just-released RubyGems"
  task "publish" => %w[
    blog:pull
    blog:update
    blog:commit
    blog:push
  ]
end

# Misc Tasks ---------------------------------------------------------

module Rubygems
  class ProjectFiles
    def self.all
      files = []
      exclude = %r{\A(?:\.|tool/|Rakefile|bin|test|spec|doc)}
      tracked_files = `git ls-files`.split("\n")

      tracked_files.each do |path|
        next unless File.file?(path)
        next if path&.match?(exclude)
        files << path
      end

      # Restore important documents
      %w[
        doc/MAINTAINERS.txt
        doc/UPGRADING.md
        doc/POLICIES.md
      ].each {|f| files << f }

      files.sort
    end
  end
end

desc "Update the manifest to reflect what's on disk"
task :update_manifest do
  File.open("Manifest.txt", "w") {|f| f.puts(Rubygems::ProjectFiles.all) }
end

desc "Check the manifest is up to date"
task :check_manifest do
  if File.read("Manifest.txt").split != Rubygems::ProjectFiles.all
    abort "Manifest is out of date. Run `rake update_manifest` to sync it"
  end
end

license_last_update = nil

desc "Update License list from SPDX.org"
task :update_licenses do
  load "tool/generate_spdx_license_list.rb"
  license_last_update = generate_spdx_license_list
end

desc "Create branch to update License list"
task update_licenses_branch: :update_licenses do
  if license_last_update
    file, mtime = license_last_update
    date = mtime.strftime("%Y-%m-%d")
    branch_name = "license-list-#{date}"

    require "open3"
    stdout, stderr, status = Open3.capture3(*%w[git ls-remote --heads origin], "refs/heads/#{branch_name}")
    raise stderr unless status.success?

    if stdout.empty?
      system(*%w[git checkout -b], branch_name, exception: true)
      system(*%w[git commit -m], "Update SPDX license list as of #{date}", *file, exception: true)
    else
      puts "A license update PR already exists"
    end
  else
    puts "Licenses are in sync"
  end
end

desc "Run specs"
task :spec do
  sh("bin/rspec")
end

namespace :dev do
  desc "Ensure dev dependencies are installed"
  task :deps do
    puts Spec::Rubygems.dev_bundle("install")
  end

  desc "Ensure dev dependencies are installed, and make sure no lockfile changes are generated"
  task frozen_deps: :deps do
    Spec::Rubygems.check_source_control_changes(
      success_message: "Development dependencies were installed and the lockfile is in sync",
      error_message: "Development dependencies were installed but the lockfile is out of sync. Commit the updated lockfile and try again"
    )
  end
end

namespace :spec do
  desc "Ensure spec dependencies are installed"
  task deps: "dev:deps" do
    Spec::Rubygems.install_test_deps
  end

  desc "Ensure spec dependencies for running in parallel are installed (deprecated)"
  task parallel_deps: "spec:deps" do
    warn "The `spec:parallel_deps` task is deprecated because test dependencies don't need parallelization. Use `spec:deps` task instead."
  end

  desc "Run all specs"
  task all: %w[spec:regular spec:realworld]

  desc "Run the regular spec suite"
  task :regular do
    sh("bin/parallel_rspec")
  end

  desc "Run the real-world spec suite"
  task :realworld do
    sh("BUNDLER_SPEC_PRE_RECORDED=1 bin/rspec --tag realworld")
  end

  namespace :realworld do
    desc "Re-record cassettes for the realworld specs"
    task :record do
      sh("rm -rf spec/support/artifice/vcr_cassettes && bin/rspec --tag realworld")
    end

    task :check_unused_cassettes do
      used_cassettes = Dir.glob("spec/support/artifice/used_vcr_cassettes/**/*.txt").flat_map {|f| File.readlines(f).map(&:strip) }
      all_cassettes = Dir.glob("spec/support/artifice/vcr_cassettes/**/*").select {|f| File.file?(f) }
      unused_cassettes = all_cassettes - used_cassettes

      raise "The following cassettes are unused:\n#{unused_cassettes.join("\n")}\n" if unused_cassettes.any?

      puts "No cassettes unused"
    end
  end
end

namespace :quality do
  desc "Check source code and documentation quality"
  task :check do
    require_relative "tool/quality_check"
    QualityCheck.run!
  end
end

desc "Check RubyGems integration"
task :check_rubygems_integration do
  # Bundler monkeypatches RubyGems in some ways that could potentially break gem activation.

  # Run a non trivial binstub activation, with two different versions of a dependent gem installed.
  sh("ruby -Ilib -S gem install reline:0.3.0 reline:0.3.1 irb && ruby -Ilib -rbundler -S irb --version")

  # With two psych versions installed, load a gem that depends on pysch and then load rubygems extensions.
  sh("ruby -Ilib -S gem install psych:5.1.1 psych:5.1.2 rdoc && ruby -Ilib -rrdoc/task -rbundler/rubygems_ext -e1")
end

desc "Check release preparations"
task :check_release_preparations do
  %w[AWS_PROFILE GITHUB_RELEASE_PAT].each do |env_var|
    if ENV[env_var].nil? || ENV[env_var] == ""
      puts "Environment variable #{env_var} is not set"
      raise unless ENV["DRYRUN"]
    end
  end
end

namespace :man do
  if RUBY_ENGINE == "jruby"
    task(:build) {}
  else
    file "index.txt" do
      index = Dir["lib/bundler/man/*.ronn"].map do |ronn|
        roff = "#{File.dirname(ronn)}/#{File.basename(ronn, ".ronn")}"
        [ronn, roff]
      end
      index.map! do |(ronn, roff)|
        date = ENV["MAN_PAGES_DATE"] || Time.now.strftime("%Y-%m-%d")
        sh "bin/ronn --warnings --roff --pipe --date #{date} #{ronn} > #{roff}"
        [File.read(ronn).split(" ").first, File.basename(roff)]
      end
      index = index.sort_by(&:first)
      justification = index.map {|(n, _f)| n.length }.max + 4
      File.open("lib/bundler/man/index.txt", "w") do |f|
        index.each do |name, filename|
          f << name.ljust(justification) << filename << "\n"
        end
      end
    end
    task build_all_pages: "index.txt"

    desc "Make sure ronn-ng is installed"
    task :check_ronn do
      Spec::Rubygems.gem_require("ronn-ng", "ronn")
    rescue Gem::LoadError => e
      abort("We couldn't activate ronn-ng (#{e.requirement}). Try `gem install ronn-ng:'#{e.requirement}'` to be able to build the help pages")
    end

    desc "Remove all built man pages"
    task :clean do
      leftovers = Dir["lib/bundler/man/*"].reject do |f|
        File.extname(f) == ".ronn"
      end
      rm leftovers if leftovers.any?
    end

    desc "Build the man pages"
    task build: [:check_ronn, :clean, :build_all_pages]

    desc "Sets target date for building man pages to the one currently present"
    task :set_current_date do
      require "date"
      ENV["MAN_PAGES_DATE"] = Date.parse(File.readlines("lib/bundler/man/bundle-add.1")[2].split('"')[5]).strftime("%Y-%m-%d")
    end

    desc "Verify man pages are in sync"
    task check: [:check_ronn, :set_current_date, :build] do
      Spec::Rubygems.check_source_control_changes(
        success_message: "Man pages are in sync",
        error_message: "Man pages are out of sync. Please run `rake man:build` and commit the results."
      )
    end
  end
end

namespace :bundler do
  require "rake/clean"
  CLOBBER.include "pkg"
  require_relative "lib/bundler/gem_helper"
  Bundler::GemHelper.install_tasks(name: "bundler")
  require_relative "spec/support/build_metadata"

  # The rubygems release task tags the release as v#{version} and creates the
  # single GitHub release covering both RubyGems and Bundler, so bundler's
  # release must not tag or create a GitHub release of its own. Drop the
  # release:source_control_push prerequisite that would add a bundler-v tag.
  Rake::Task["bundler:release"].clear
  desc "Push bundler-#{Bundler::GemHelper.gemspec.version}.gem to rubygems.org"
  task release: ["build", "release:guard_clean", "release:rubygem_push"]

  desc "Write build metadata file in preparation for release"
  task :build_metadata do
    Spec::BuildMetadata.write_build_metadata
  end

  namespace :build_metadata do
    desc "Reset build metadata file after release"
    task :clean do
      Spec::BuildMetadata.reset_build_metadata
    end
  end

  task build: ["bundler:build_metadata"] do
    Rake::Task["bundler:build_metadata:clean"].tap(&:reenable).invoke
  end

  task "build" => ["bundler:release:check_ruby_version"]

  desc "Push to rubygems.org"
  task "release:rubygem_push" => ["man:check", "bundler:build_metadata"]

  namespace :release do
    task :check_ruby_version do
      raise "bundler:build need to released Ruby for using nokogiri" if RUBY_PATCHLEVEL.to_i < 0
    end
  end
end

[:test, :spec, "spec:regular"].each do |name|
  Rake::Task[name].enhance do
    Rake::Task["coverage:report"].reenable
    Rake::Task["coverage:report"].invoke
  end
end
