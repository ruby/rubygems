# frozen_string_literal: true

require_relative "../command"
require_relative "../local_remote_options"
require_relative "../remote_fetcher"
require_relative "../resolver"
require_relative "../version_option"

class Gem::Commands::FetchCommand < Gem::Command
  include Gem::LocalRemoteOptions
  include Gem::VersionOption

  def initialize
    defaults = {
      suggest_alternate: true,
      version: Gem::Requirement.default,
    }

    super "fetch", "Download a gem and place it in the current directory", defaults

    add_bulk_threshold_option
    add_proxy_option
    add_source_option
    add_clear_sources_option

    add_version_option
    add_platform_option
    add_prerelease_option

    add_option "--[no-]suggestions", "Suggest alternates when gems are not found" do |value, options|
      options[:suggest_alternate] = value
    end
  end

  def arguments # :nodoc:
    "GEMNAME       name of gem to download"
  end

  def defaults_str # :nodoc:
    "--version '#{Gem::Requirement.default}'"
  end

  def description # :nodoc:
    <<-EOF
The fetch command fetches gem files that can be stored for later use or
unpacked to examine their contents.

See the build command help for an example of unpacking a gem, modifying it,
then repackaging it.
    EOF
  end

  def usage # :nodoc:
    "#{program_name} GEMNAME [GEMNAME ...]"
  end

  def check_version # :nodoc:
    if options[:version] != Gem::Requirement.default &&
       get_all_gem_names.size > 1
      alert_error "Can't use --version with multiple gems. You can specify multiple gems with" \
                  " version requirements using `gem fetch 'my_gem:1.0.0' 'my_other_gem:>=2'`"
      terminate_interaction 1
    end
  end

  def execute
    check_version

    exit_code = fetch_gems

    terminate_interaction exit_code
  end

  private

  def fetch_gems
    exit_code = 0

    version = options[:version]

    platform  = Gem.platforms.last
    gem_names = get_all_gem_names_and_versions

    # A BestSet reads a source's compact index when it serves one, the same way
    # gems are looked up when installing them.
    remote_set = Gem::Resolver::BestSet.new

    gem_names.each do |gem_name, gem_version|
      gem_version ||= version
      dep = Gem::Dependency.new gem_name, gem_version
      dep.prerelease = options[:prerelease]
      suppress_suggestions = !options[:suggest_alternate]

      remote_specs, errors = find_remote_specs dep, remote_set

      if platform
        filtered = remote_specs.select {|s| s.platform == platform }
        remote_specs = filtered unless filtered.empty?
      end

      remote_spec = remote_specs.max_by {|s| [s.version, Gem::Platform.sort_priority(s.platform)] }

      if remote_spec.nil?
        show_lookup_failure gem_name, gem_version, errors, suppress_suggestions, options[:domain]
        exit_code |= 2
        next
      end

      spec = remote_spec.spec
      remote_spec.source.download spec
      say "Downloaded #{spec.full_name}"
    end

    exit_code
  end

  # Find specs in +set+ that match +dep+ and can be used on this platform,
  # along with the reasons any other spec was rejected.

  def find_remote_specs(dep, set)
    set.prerelease = dep.prerelease?

    request = Gem::Resolver::DependencyRequest.new dep, nil

    matching, mismatched = set.find_all(request).partition do |spec|
      Gem::Platform.match_spec? spec
    end

    [matching, set.errors + platform_mismatches(mismatched)]
  end

  def platform_mismatches(specs)
    specs.group_by {|spec| [spec.name, spec.version] }.map do |(name, version), group|
      mismatch = Gem::PlatformMismatch.new name, version
      group.each {|spec| mismatch.add_platform spec.platform.to_s }
      mismatch
    end
  end
end
