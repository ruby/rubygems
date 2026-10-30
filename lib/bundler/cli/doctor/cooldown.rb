# frozen_string_literal: true

module Bundler
  class CLI::Doctor::Cooldown
    attr_reader :options

    def initialize(options)
      @options = options
    end

    def run
      Bundler::CLI::Common.configure_cooldown(options)

      unless Bundler.default_lockfile.exist?
        raise GemfileLockNotFound, "There is no #{SharedHelpers.relative_lockfile_path} to check. " \
          "Run `bundle lock` to create one."
      end

      # Read the lockfile the way a frozen install does: as written, without
      # adding the local platform, re-resolving, or rewriting it.
      specs = Bundler.settings.temporary(frozen: true) { Bundler.definition.resolve }

      sources = specs.map(&:source).uniq.select {|source| source.is_a?(Source::Rubygems) && cooldown_active?(source) }
      specs = specs.select {|spec| sources.include?(spec.source) }

      if specs.empty?
        Bundler.ui.info "No cooldown applies to the locked gems, so there is nothing to check"
        return
      end

      sources.each(&:remote!)

      in_cooldown = []
      unknown = []

      # Like the resolver, judge a version by every published build of it, not
      # only the locked platforms, so a fresh platform-specific build pushed
      # under an old version number still counts.
      specs.uniq {|spec| [spec.name, spec.version] }.sort_by(&:name).each do |spec|
        published = spec.source.specs.search([spec.name, spec.version]).select do |remote_spec|
          remote_spec.respond_to?(:created_at) && remote_spec.created_at
        end

        if published.empty?
          unknown << spec
        elsif (remaining = published.filter_map {|remote_spec| cooldown_days_remaining(remote_spec) }.max)
          in_cooldown << [spec, remaining]
        end
      end

      # The cooldown fails open on a missing publish time everywhere else, but
      # a check that quietly skips gems would pass in CI without checking them.
      if unknown.any?
        Bundler.ui.warn "Could not find a publish time for the following locked gems, so the cooldown was not checked for them:"
        unknown.each {|spec| Bundler.ui.warn "  * #{spec.name} #{spec.version}" }
      end

      if in_cooldown.empty?
        Bundler.ui.info "No locked gems are inside the cooldown window"
        return
      end

      Bundler.ui.error "The following locked gems are inside the cooldown window:"
      in_cooldown.each do |spec, remaining|
        Bundler.ui.error "  * #{spec.name} #{spec.version} (in cooldown for #{remaining} more day#{"s" if remaining > 1})"
      end
      exit 1
    end

    private

    # Building the remotes reads the cooldown settings without any network
    # access, so a bundle with no cooldown configured is never fetched.
    def cooldown_active?(source)
      source.remote_fetchers.keys.any? {|remote| remote.effective_cooldown.to_i > 0 }
    end

    def cooldown_days_remaining(spec)
      return unless spec.respond_to?(:remote) && spec.remote
      days = spec.remote.effective_cooldown
      return if days.nil? || days <= 0
      remaining = days - ((cooldown_now - spec.created_at) / 86_400.0)
      remaining.ceil if remaining > 0
    end

    def cooldown_now
      @cooldown_now ||= Time.now
    end
  end
end
