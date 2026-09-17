# frozen_string_literal: true

module Bundler
  class CLI::Up
    OPERATOR_FLAGS = [:exact, :tilde, :gte, :lte].freeze

    attr_reader :options, :patterns

    def initialize(options, patterns)
      @options = options
      @patterns = patterns
    end

    def run
      Bundler.ui.level = "warn" if options[:quiet]

      validate_options!
      Bundler::CLI::Common.configure_cooldown(options)

      deps = direct_dependencies
      targets = expand_patterns(deps)
      filter_by_group!(targets)
      check_lockfile!

      plan = resolve_targets(targets)
      return Bundler.ui.info("Bundle up to date!") if plan.empty?

      plan = confirm_interactive(plan) if options[:interactive]
      return Bundler.ui.info("Nothing to update.") if plan.empty?

      requirements = plan.to_h do |dep, info|
        [dep.name, info[:requirements] || requirement_for(info[:target], dep, info[:pin])]
      end

      # The Gemfile is rewritten before the install runs, so restore it if the
      # install fails. Otherwise a requirement could be left pinned to a
      # version that does not resolve.
      rewritten = with_rollback do
        names = Injector.update_requirements(requirements)
        if names.empty?
          raise GemfileError, "None of the selected gems are declared in the Gemfile, so nothing was updated."
        end

        install_updates(plan)
        names
      end

      report(plan, rewritten, requirements)
    end

    private

    def validate_options!
      raise InvalidOption, "Please specify gems to update. See `bundle help up`." if patterns.empty?

      modifiers = OPERATOR_FLAGS.select {|flag| options[flag] }
      raise InvalidOption, "Provide only one of --exact, --tilde, --gte, --lte." if modifiers.size > 1

      if options[:version] && modifiers.any?
        raise InvalidOption, "Provide only one of --version and --exact, --tilde, --gte, --lte."
      end
    end

    def direct_dependencies
      Bundler.definition.dependencies.select(&:gemfile_dep?)
    end

    # Splits patterns like `rails@8.0.0` into a name pattern plus an explicit
    # version pin, and expands globs against direct Gemfile dependencies.
    # `--version` applies as a pin to every match. Returns a hash of
    # dependency name to explicit pin (or nil).
    def expand_patterns(deps)
      by_name = deps.group_by(&:name)
      targets = {}

      patterns.each do |pattern|
        name_pattern, pin = split_pattern(pattern)
        if pin && options[:version]
          raise InvalidOption, "Cannot combine `gem@version` pins with --version. Use one or the other."
        end
        pin ||= options[:version]

        matches = by_name.keys.select {|name| File.fnmatch(name_pattern, name) }
        if matches.empty?
          raise GemNotFound, CLI::Common.gem_not_found_message(name_pattern, by_name.keys)
        end

        matches.each do |name|
          # explicit pins win, but a bare pattern must not override a pin
          targets[name] = pin if !targets.key?(name) || pin
        end
      end

      targets
    end

    def split_pattern(pattern)
      index = pattern.rindex("@")
      return [pattern, nil] if index.nil? || index.zero? || index == pattern.length - 1

      [pattern[0...index], pattern[(index + 1)..]]
    end

    def filter_by_group!(targets)
      groups = Array(options[:group]).map(&:to_sym)
      return if groups.empty?

      deps = Bundler.definition.dependencies.select {|d| targets.key?(d.name) }
      deps.each do |dep|
        targets.delete(dep.name) if (dep.groups.map(&:to_sym) & groups).empty?
      end

      raise InvalidOption, "None of the selected gems are in group(s) #{groups.join(", ")}." if targets.empty?
    end

    def check_lockfile!
      return if Bundler.default_lockfile.exist?

      raise GemfileLockNotFound, "This Bundle hasn't been installed yet. " \
        "Run `bundle install` to install the bundled gems before running `bundle up`."
    end

    # Finds the version each selected gem should move to: the explicit pin,
    # or the newest available version honoring --patch/--minor/--pre/--strict.
    def resolve_targets(targets)
      Bundler.definition.validate_runtime!

      current_specs = Bundler.ui.silence { Bundler.definition.resolve }

      definition = Bundler.definition(gems: targets.keys)
      CLI::Common.configure_gem_version_promoter(definition, options.merge(strict: strict?))
      if options[:local]
        definition.resolve_with_cache!
      else
        definition.resolve_remotely!
      end

      plan = {}
      targets.each do |name, pin|
        current_spec = current_specs[name]&.max_by(&:version)
        unless current_spec
          raise GemNotFound, "Could not find gem '#{name}' in the bundle."
        end

        active_spec = definition.resolve.find_by_name_and_platform(name, current_spec.platform)
        unless active_spec
          Bundler.ui.warn "Bundler attempted to update #{name} but it could not be resolved, skipping."
          next
        end

        unless active_spec.source.is_a?(Source::Rubygems)
          Bundler.ui.warn "Bundler attempted to update #{name} but it comes from #{active_spec.source.class}, skipping."
          next
        end

        if pin
          plan[name] = pinned_plan(name, pin, current_spec, active_spec)
          next if plan[name].nil?
        else
          dep = dep_for(name)
          target = newest_version(name, current_spec, active_spec)
          if target.nil? || target <= current_spec.version
            # Already at the newest version: still rewrite when an operator
            # flag explicitly requests a different requirement.
            next unless operator_flag_given? && requirement_changed?(dep, current_spec.version)

            target = current_spec.version
          end

          plan[name] = { dep: dep, current: current_spec.version, target: target, requirements: nil, pin: false }
        end
      end
      plan.to_h do |_name, info|
        [info[:dep], { current: info[:current], target: info[:target], requirements: info[:requirements], pin: info[:pin] }]
      end
    end

    def dep_for(name)
      Bundler.definition.dependencies.find {|d| d.name == name }
    end

    def operator_flag_given?
      OPERATOR_FLAGS.any? {|flag| options[flag] }
    end

    # Whether an operator flag would rewrite the declaration differently
    # from what's already in the Gemfile.
    def requirement_changed?(dep, version)
      computed = requirement_for(version, dep, false)
      Gem::Requirement.new([computed]).as_list != dep.requirement.as_list
    rescue ArgumentError
      true
    end

    # A pin may be a single version (`8.0.0`, `= 8.0.0`) or a compound
    # requirement (`> 5.0.0, < 5.1.1`). Exact pins resolve to a target
    # version up front; anything else is written verbatim and resolved by
    # the install step.
    def pinned_plan(name, pin, current_spec, active_spec)
      requirement = parse_pin_requirement(name, pin)
      parts = requirement.as_list

      unless single_exact?(requirement)
        return { dep: dep_for(name), current: current_spec.version, target: nil, requirements: parts, pin: false }
      end

      version = requirement.requirements.first.last
      available = matching_specs(active_spec, current_spec)
      unless available.any? {|spec| spec.version == version }
        raise GemNotFound, "Could not find version #{version} for gem '#{name}' in the available sources."
      end

      { dep: dep_for(name), current: current_spec.version, target: version, requirements: nil, pin: true }
    end

    def parse_pin_requirement(name, pin)
      parts = pin.split(",").map(&:strip).reject(&:empty?)
      raise InvalidOption, "Invalid version pin #{pin.dump} for gem '#{name}'." if parts.empty?

      Gem::Requirement.new(parts)
    rescue ArgumentError => e
      raise InvalidOption, "Invalid version pin #{pin.dump} for gem '#{name}': #{e.message}"
    end

    def single_exact?(requirement)
      constraints = requirement.requirements
      constraints.size == 1 && constraints.first.first == "="
    end

    def newest_version(name, current_spec, active_spec)
      candidates = matching_specs(active_spec, current_spec)
      candidates.select! {|spec| spec.version > current_spec.version }
      # --patch/--minor only move a gem within its current level, so a gem with
      # nothing newer at that level is left alone instead of being promoted to
      # the next level. Passing --strict additionally constrains the install
      # resolution, matching `bundle update --patch/--minor`. For the default
      # --major level `within_level?` accepts every candidate.
      candidates.select! {|spec| within_level?(spec.version, current_spec.version) }
      return if candidates.empty?

      candidates.max_by(&:version).version
    end

    def matching_specs(active_spec, current_spec)
      active_specs = active_spec.source.specs.search(current_spec.name).select do |spec|
        spec.installable_on_platform?(current_spec.platform)
      end.sort_by(&:version)
      if !current_spec.version.prerelease? && !options[:pre] && active_specs.size > 1
        active_specs.delete_if {|spec| spec.respond_to?(:version) && spec.version.prerelease? }
      end
      active_specs
    end

    def within_level?(version, locked)
      level = patch_level
      return true if level == :major
      return false unless version.segments[0] == locked.segments[0]
      return true if level == :minor
      version.segments[1].to_i == locked.segments[1].to_i
    end

    def patch_level
      levels = CLI::Common.patch_level_options(options)
      levels.empty? ? :major : levels.first.to_sym
    end

    def strict?
      options[:strict]
    end

    def confirm_interactive(plan)
      plan.reject do |dep, info|
        # Compound pins and declarative requirements have no single target
        # version, so show the requirement that will be written instead.
        target = info[:target] || Array(info[:requirements]).join(", ")
        # `ask` returns nil when stdin is not available (a script or CI run),
        # which stands for the default answer advertised by the prompt.
        answer = Bundler.ui.ask("Update #{dep.name} from #{info[:current]} to #{target}? (Y/n) ")
        answer.to_s.strip.casecmp?("n")
      end
    end

    def requirement_for(target, dep, pinned)
      return "= #{target}" if pinned

      if options[:exact]
        "= #{target}"
      elsif options[:tilde]
        "~> #{target}"
      elsif options[:gte]
        ">= #{target}"
      elsif options[:lte]
        "<= #{target}"
      else
        preserve_operator(dep, target)
      end
    end

    # Keeps the operator already declared in the Gemfile. Operators are read
    # from the source text (not the parsed requirement) so a bare `"1.0"`
    # is treated as unconstrained, while an explicit `"= 1.0"` is preserved.
    def preserve_operator(dep, target)
      operators = declared_operators(dep)
      return preserve_requirement_operator(dep.requirement, target) if operators.nil?
      return "~> #{target}" if operators.empty?

      case operators.first
      when "~>", ">=", "="
        "#{operators.first} #{target}"
      when ">"
        first = dep.requirement.as_list.first.to_s
        Bundler.ui.warn "Rewriting `#{first}` as `>= #{target}`, since `> #{target}` would exclude the resolved version."
        ">= #{target}"
      when nil
        # Bare version with no operator stays bare, only the version moves.
        target.to_s
      else
        first = dep.requirement.as_list.first.to_s
        Bundler.ui.warn "Rewriting `#{first}` as `~> #{target}`, since ceilings cannot be preserved when moving to a newer version."
        "~> #{target}"
      end
    end

    def declared_operators(dep)
      return if dep.gemfile.nil?

      Injector.declared_operators(dep.gemfile, dep.name)
    end

    # Fallback when the declaration cannot be read back: derive the operator
    # from the parsed requirement, treating it as explicitly written.
    def preserve_requirement_operator(requirement, target)
      first = requirement.as_list.first.to_s
      return "~> #{target}" if first == ">= 0"

      operator = first[/\A(>=|>|<=|<|~>|=|!=)/, 1]
      case operator
      when "~>", ">=", "="
        "#{operator} #{target}"
      when ">"
        Bundler.ui.warn "Rewriting `#{first}` as `>= #{target}`, since `> #{target}` would exclude the resolved version."
        ">= #{target}"
      else
        Bundler.ui.warn "Rewriting `#{first}` as `~> #{target}`, since ceilings cannot be preserved when moving to a newer version."
        "~> #{target}"
      end
    end

    def install_updates(plan)
      names = plan.keys.map(&:name)

      Bundler::CLI::Common.ensure_all_gems_in_lockfile!(names)

      Bundler.definition(gems: names)
      Bundler::CLI::Common.configure_gem_version_promoter(Bundler.definition, options)

      opts = options.dup
      opts["update"] = true
      opts["local"] = options[:local]

      Bundler.definition.validate_runtime!

      previous = locked_versions(names)

      installer = Installer.install Bundler.root, Bundler.definition, opts
      Bundler.load.cache if Bundler.app_cache.exist?

      if CLI::Common.clean_after_install?
        require_relative "clean"
        Bundler::CLI::Clean.new(options).run
      else
        CLI::Common.prune(options)
      end

      warn_if_unchanged(names, previous)

      CLI::Common.output_post_install_messages installer.post_install_messages
      CLI::Common.output_cooldown_skipped_summary
      CLI::Common.output_fund_metadata_summary
    end

    # `up` rewrites the Gemfile before installing, so a failed install would
    # otherwise leave a requirement pinned to a version that could not be
    # resolved. Restore the Gemfile(s) and the lockfile when anything goes
    # wrong, the same outcome `bundle add` gets by only writing the Gemfile
    # after resolution succeeds.
    def with_rollback
      snapshot = gemfile_snapshot

      begin
        yield
      rescue StandardError, Interrupt
        restore_gemfiles(snapshot)
        raise
      end
    end

    def gemfile_snapshot
      (Bundler.definition.gemfiles + [Bundler.default_lockfile]).each_with_object({}) do |path, snapshot|
        snapshot[path] = File.file?(path) ? File.read(path) : nil
      end
    end

    def restore_gemfiles(snapshot)
      snapshot.each do |path, contents|
        if contents.nil?
          File.delete(path) if File.file?(path)
        else
          File.write(path, contents)
        end
      end
      Bundler.reset_paths!
    end

    def locked_versions(names)
      return {} unless (locked = Bundler.definition.locked_gems)

      locked.specs.each_with_object({}) do |spec, hash|
        hash[spec.name] = spec.version if names.include?(spec.name)
      end
    end

    def warn_if_unchanged(names, previous)
      names.each do |name|
        new_spec = Bundler.definition.specs[name].first
        next unless new_spec && previous[name]

        if new_spec.version == previous[name]
          Bundler.ui.warn "Bundler attempted to update #{name} but its version stayed the same"
        elsif new_spec.version < previous[name]
          Bundler.ui.warn "Note: #{name} version regressed from #{previous[name]} to #{new_spec.version}"
        end
      end
    end

    def report(plan, rewritten, requirements)
      specs = Bundler.definition.specs
      plan.each do |dep, info|
        next unless rewritten.include?(dep.name)

        new_version = info[:target] || specs[dep.name].first&.version
        if new_version == info[:current]
          new_requirement = Array(requirements[dep.name]).join(", ")
          Bundler.ui.confirm "#{dep.name} requirement updated to #{new_requirement.dump} (already at #{info[:current]})"
        else
          Bundler.ui.confirm "#{dep.name} updated from #{info[:current]} to #{new_version}"
        end
      end
      Bundler.ui.confirm "Bundle up!"
      Bundler::CLI::Common.output_without_groups_message(:update)
    end
  end
end
