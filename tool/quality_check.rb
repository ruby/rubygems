# frozen_string_literal: true

require "rubygems/package"
require "tmpdir"

# Repository quality checks for the Bundler part of this repo, run in CI
# through `rake quality:check`.
class QualityCheck
  def self.run!
    new.run!
  end

  def initialize
    @source_root = File.expand_path("..", __dir__)
    @errors = []
  end

  def run!
    check_no_malformed_whitespace
    check_no_extraneous_quotes
    check_no_merge_conflicts
    check_man_language_quality
    check_lib_language_quality
    check_documented_settings
    check_vendored_net_http_sync
    check_gem_build
    check_shipped_files

    if @errors.empty?
      puts "Quality checks passed"
    else
      raise "Quality check failures:\n\n#{@errors.join("\n")}"
    end
  end

  private

  def check_no_malformed_whitespace
    exempt = /\.gitmodules|fixtures|vendor|LICENSE|vcr_cassettes|rbreadline\.diff|index\.txt$/
    tracked_files.each do |filename|
      next if filename&.match?(exempt)
      add_error check_for_tab_characters(filename)
      add_error check_for_extra_spaces(filename)
    end
  end

  def check_no_extraneous_quotes
    exempt = /vendor|vcr_cassettes|LICENSE|rbreadline\.diff/
    tracked_files.each do |filename|
      next if filename&.match?(exempt)
      add_error check_for_extraneous_quotes(filename)
    end
  end

  def check_no_merge_conflicts
    exempt = %r{lock/lockfile_spec|vcr_cassettes|\.ronn|lockfile_parser}
    tracked_files.each do |filename|
      next if filename&.match?(exempt)
      add_error check_for_git_merge_conflicts(filename)
    end
  end

  def check_man_language_quality
    man_tracked_files.each do |filename|
      @errors.concat(check_for_expendable_words(filename))
      @errors.concat(check_for_specific_pronouns(filename))
    end
  end

  def check_lib_language_quality
    exempt = /vendor|vcr_cassettes|CODE_OF_CONDUCT/
    lib_tracked_files.each do |filename|
      next if filename&.match?(exempt)
      @errors.concat(check_for_expendable_words(filename))
      @errors.concat(check_for_specific_pronouns(filename))
    end
  end

  def check_documented_settings
    lib = File.join(@source_root, "lib")
    $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
    require "bundler/settings"

    exemptions = %w[
      gem.changelog
      gem.ci
      gem.coc
      gem.linter
      gem.mit
      gem.bundle
      gem.rubocop
      gem.test
      git.allow_insecure
      inline
      trust-policy
    ]

    all_settings = Hash.new {|h, k| h[k] = [] }

    Bundler::Settings::BOOL_KEYS.each {|k| all_settings[k] << "in Bundler::Settings::BOOL_KEYS" }
    Bundler::Settings::NUMBER_KEYS.each {|k| all_settings[k] << "in Bundler::Settings::NUMBER_KEYS" }
    Bundler::Settings::ARRAY_KEYS.each {|k| all_settings[k] << "in Bundler::Settings::ARRAY_KEYS" }
    Bundler::Settings::STRING_KEYS.each {|k| all_settings[k] << "in Bundler::Settings::STRING_KEYS" }

    key_pattern = /([a-z\._-]+)/i
    lib_tracked_files.each do |filename|
      each_line(filename) do |line, number|
        line.scan(/Bundler\.settings\[:#{key_pattern}\]/).flatten.each {|s| all_settings[s] << "referenced at `#{filename}:#{number.succ}`" }
      end
    end
    settings_section = File.read(File.join(@source_root, "lib/bundler/man/bundle-config.1.ronn")).split(/^## /).find {|section| section.start_with?("LIST OF AVAILABLE KEYS") }
    documented_settings = settings_section.scan(/^\* `#{key_pattern}`/).flatten

    documented_settings.each do |s|
      all_settings.delete(s)
      @errors << "setting #{s} was exempted but was actually documented" unless exemptions.delete(s).nil?
    end

    exemptions.each do |s|
      @errors << "setting #{s} was exempted but unused" unless all_settings.delete(s)
    end

    all_settings.sort.each do |setting, refs|
      @errors << "The `#{setting}` setting is undocumented\n\t- #{refs.join("\n\t- ")}\n"
    end

    unless documented_settings == documented_settings.sort
      @errors << "settings documented in bundle-config.1.ronn are not sorted, expected order:\n\t#{documented_settings.sort.join("\n\t")}"
    end
  end

  # We don't want our artifice code to activate bundler, but it needs to use the
  # namespaced implementation of `Net::HTTP`. So we duplicate the file in
  # bundler that loads that.
  def check_vendored_net_http_sync
    lib_implementation_path = File.join(@source_root, "lib", "bundler", "vendored_net_http.rb")
    spec_implementation_path = File.join(@source_root, "spec", "support", "vendored_net_http.rb")

    missing = [lib_implementation_path, spec_implementation_path].reject {|path| File.exist?(path) }
    unless missing.empty?
      missing.each {|path| @errors << "#{path} does not exist" }
      return
    end

    return if File.read(lib_implementation_path) == File.read(spec_implementation_path)
    @errors << "#{spec_implementation_path} is out of sync with #{lib_implementation_path}"
  end

  def check_gem_build
    Dir.mktmpdir do |dir|
      gem_path = File.join(dir, loaded_gemspec.file_name)
      Dir.chdir(@source_root) do
        Gem::DefaultUserInteraction.use_ui(Gem::SilentUI.new) do
          Gem::Package.build(loaded_gemspec.dup, false, false, gem_path)
        end
      end
      @errors << "building bundler.gemspec did not produce a gem file" unless File.exist?(gem_path)
    end
  rescue StandardError => e
    @errors << "bundler.gemspec could not be built: #{e.class}: #{e.message}"
  end

  def check_shipped_files
    git_list = tracked_files.reject {|f| f.start_with?("spec/") }
    gem_list = loaded_gemspec.files

    (git_list - gem_list).each do |file|
      @errors << "#{file} is tracked in git but not shipped in the gem"
    end
    (gem_list - git_list).each do |file|
      @errors << "#{file} is shipped in the gem but not tracked in git"
    end
  end

  def add_error(message)
    @errors << message if message
  end

  def check_for_git_merge_conflicts(filename)
    merge_conflicts_regex = /
      <<<<<<<|
      =======|
      >>>>>>>
    /x

    failing_lines = []
    each_line(filename) do |line, number|
      failing_lines << number + 1 if line&.match?(merge_conflicts_regex)
    end

    return if failing_lines.empty?
    "#{filename} has unresolved git merge conflicts on lines #{failing_lines.join(", ")}"
  end

  def check_for_tab_characters(filename)
    # Because Go uses hard tabs
    return if filename.end_with?(".go.tt")

    failing_lines = []
    each_line(filename) do |line, number|
      failing_lines << number + 1 if line.include?("\t")
    end

    return if failing_lines.empty?
    "#{filename} has tab characters on lines #{failing_lines.join(", ")}"
  end

  def check_for_extra_spaces(filename)
    failing_lines = []
    each_line(filename) do |line, number|
      next if /^\s+#.*\s+\n$/.match?(line)
      failing_lines << number + 1 if /\s+\n$/.match?(line)
    end

    return if failing_lines.empty?
    "#{filename} has spaces on the EOL on lines #{failing_lines.join(", ")}"
  end

  def check_for_extraneous_quotes(filename)
    failing_lines = []
    each_line(filename) do |line, number|
      failing_lines << number + 1 if /\u{2019}/.match?(line)
    end

    return if failing_lines.empty?
    "#{filename} has an extraneous quote on lines #{failing_lines.join(", ")}"
  end

  def check_for_expendable_words(filename)
    failing_line_message = []
    useless_words = %w[
      actually
      basically
      clearly
      just
      obviously
      really
      simply
    ]
    pattern = /\b#{Regexp.union(useless_words)}\b/i

    each_line(filename) do |line, number|
      next unless word_found = pattern.match(line)
      failing_line_message << "#{filename}:#{number.succ} has '#{word_found}'. Avoid using these kinds of weak modifiers."
    end

    failing_line_message
  end

  def check_for_specific_pronouns(filename)
    failing_line_message = []
    specific_pronouns = /\b(he|she|his|hers|him|her|himself|herself)\b/i

    each_line(filename) do |line, number|
      next unless word_found = specific_pronouns.match(line)
      failing_line_message << "#{filename}:#{number.succ} has '#{word_found}'. Use more generic pronouns in documentation."
    end

    failing_line_message
  end

  def tracked_files
    @tracked_files ||= git_ls_files("exe/bundle exe/bundler lib/bundler lib/bundler.rb lib/rubygems/vendor/uri lib/rubygems/vendor/securerandom lib/rubygems/vendor/pub_grub lib/rubygems/yaml_serializer.rb lib/rubygems/cooldown_settings.rb lib/rubygems/compact_index_client* lib/rubygems/credential_store* bundler.gemspec MIT.txt")
  end

  def lib_tracked_files
    @lib_tracked_files ||= git_ls_files("lib/bundler lib/bundler.rb")
  end

  def man_tracked_files
    @man_tracked_files ||= git_ls_files("lib/bundler/man/bundle*.1.ronn lib/bundler/man/gemfile*.5.ronn")
  end

  def git_ls_files(globs)
    IO.popen(["git", "ls-files", "-z", "--", *globs.split(" ")], chdir: @source_root, &:read).split("\x0")
  end

  def loaded_gemspec
    @loaded_gemspec ||= Dir.chdir(@source_root) { Gem::Specification.load("bundler.gemspec") }
  end

  def each_line(filename, &block)
    File.readlines(File.expand_path(filename, @source_root), encoding: "UTF-8").each_with_index(&block)
  end
end
