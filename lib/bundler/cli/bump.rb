# frozen_string_literal: true

module Bundler
  class CLI::Bump
    # The operator each operator flag writes.
    OPERATOR_FLAGS = { exact: "=", tilde: "~>", gte: ">=", lte: "<=" }.freeze

    OPERATOR = /\A\s*(>=|>|<=|<|~>|=|!=)/

    attr_reader :options, :patterns

    def initialize(options, patterns)
      @options = options
      @patterns = patterns
    end

    def run
      Bundler.ui.level = "warn" if options[:quiet]

      validate_options!
      check_frozen!
      CLI::Common.configure_cooldown(options)

      targets = expand_patterns
      filter_by_group!(targets)
      check_lockfile!

      plan = resolve_targets(targets)
      return Bundler.ui.info("Bundle up to date!") if plan.empty?

      plan = confirm_interactive(plan) if options[:interactive]
      return Bundler.ui.info("Nothing to update.") if plan.empty?

      plan.each_value {|info| Bundler.ui.warn info[:warning] if info[:warning] }

      # The Gemfile is rewritten before the install runs, so restore it if the
      # install fails. Otherwise a requirement could be left pinned to a
      # version that does not resolve.
      with_rollback do
        rewrite_gemfile(plan)
        install_updates(plan.keys)
      end

      report(plan)
    end

    private

    def validate_options!
      if options[:all] && (patterns.any? || Array(options[:group]).any?)
        raise InvalidOption, "Cannot specify --all along with specific options."
      end
      raise InvalidOption, "Please specify gems to update. See `bundle help bump`." if patterns.empty? && !options[:all]
      raise InvalidOption, "Cannot combine --all with --version, since it would pin every gem to the same requirement." if options[:all] && options[:version]

      flags = OPERATOR_FLAGS.keys.select {|flag| options[flag] }
      raise InvalidOption, "Provide only one of --exact, --tilde, --gte, --lte." if flags.size > 1
      raise InvalidOption, "Provide only one of --version and --exact, --tilde, --gte, --lte." if options[:version] && flags.any?
    end

    def check_frozen!
      return unless Bundler.frozen_bundle?

      raise ProductionError, "The Gemfile can't be bumped because frozen mode is set. " \
        "Run `bundle bump` elsewhere and add the updated Gemfile and #{SharedHelpers.relative_lockfile_path} to version control."
    end

    # @return [Hash{String => Bundler::Dependency}] the gems declared in the Gemfile.
    def direct_dependencies
      @direct_dependencies ||= Bundler.definition.dependencies.select(&:gemfile_dep?).to_h {|dep| [dep.name, dep] }
    end

    # Splits patterns like `rails@8.0.0` into a name pattern plus an explicit
    # requirement pin, and expands globs against the gems declared in the
    # Gemfile. `--version` applies as a pin to every match.
    # @return [Hash{String => Array<String>, nil}] gem name to pinned requirements.
    def expand_patterns
      names = direct_dependencies.keys
      return names.to_h {|name| [name, nil] } if options[:all]

      patterns.each_with_object({}) do |pattern, targets|
        name_pattern, pin = split_pattern(pattern)
        raise InvalidOption, "Cannot combine `gem@version` pins with --version. Use one or the other." if pin && options[:version]
        pin ||= options[:version]

        matches = names.select {|name| File.fnmatch(name_pattern, name) }
        raise GemNotFound, CLI::Common.gem_not_found_message(name_pattern, names) if matches.empty?

        matches.each do |name|
          requirements = pin && parse_pin(name, pin)
          if requirements && targets[name] && targets[name] != requirements
            raise InvalidOption, "Conflicting version pins for #{name}: #{targets[name].join(", ").dump} and #{requirements.join(", ").dump}."
          end
          # explicit pins win, but a bare pattern must not override a pin
          targets[name] ||= requirements
        end
      end
    end

    def split_pattern(pattern)
      index = pattern.rindex("@")
      return [pattern, nil] if index.nil? || index.zero? || index == pattern.length - 1

      [pattern[0...index], pattern[(index + 1)..]]
    end

    # A pin is a single version (`8.0.0`, `= 8.0.0`) or requirement, or a
    # comma separated compound (`> 5.0.0, < 5.1.1`).
    def parse_pin(name, pin)
      parts = pin.split(",").reject {|part| part.strip.empty? }
      raise InvalidOption, "Invalid version pin #{pin.dump} for gem '#{name}'." if parts.empty?

      Gem::Requirement.new(parts).as_list
    rescue ArgumentError => e
      raise InvalidOption, "Invalid version pin #{pin.dump} for gem '#{name}': #{e.message}"
    end

    def filter_by_group!(targets)
      groups = Array(options[:group]).map(&:to_sym)
      return if groups.empty?

      targets.delete_if {|name, _| (direct_dependencies[name].groups & groups).empty? }
      raise InvalidOption, "None of the selected gems are in group(s) #{groups.join(", ")}." if targets.empty?
    end

    def check_lockfile!
      return if Bundler.default_lockfile.exist?

      raise GemfileLockNotFound, "This Bundle hasn't been installed yet. " \
        "Run `bundle install` to install the bundled gems before running `bundle bump`."
    end

    # Finds the version each selected gem moves to by resolving the bundle
    # with their requirements relaxed: the explicit pin, or anything from the
    # locked version up, kept inside the --patch/--minor level. The resolver
    # then only picks versions that work with the current Ruby, the rest of
    # the bundle and the cooldown setting.
    def resolve_targets(targets)
      Bundler.definition.validate_runtime!
      current_specs = Bundler.ui.silence { Bundler.definition.resolve }

      locked = targets.each_key.with_object({}) do |name, versions|
        spec = current_specs[name].max_by(&:version)
        if spec.nil?
          Bundler.ui.warn "Bundler attempted to bump #{name} but it is not in the bundle for the current platform, skipping."
        elsif !spec.source.is_a?(Source::Rubygems)
          Bundler.ui.warn "Bundler attempted to bump #{name} but it comes from #{spec.source.class}, skipping."
        else
          versions[name] = spec.version
        end
      end
      return {} if locked.empty?

      resolved = resolve_with(locked.to_h {|name, version| [name, targets[name] || level_requirement(version)] })

      locked.each_with_object({}) do |(name, current), plan|
        entry = plan_entry(name, current, resolved[name].max_by(&:version).version, targets[name])
        plan[name] = entry if entry
      end
    end

    def level_requirement(version)
      major, minor = version.segments

      case CLI::Common.patch_level_options(options).first
      when :minor then [">= #{version}", "~> #{major}.0"]
      when :patch then [">= #{version}", "~> #{major}.#{minor.to_i}.0"]
      else [">= #{version}"]
      end
    end

    def resolve_with(requirements)
      builder = Dsl.new
      builder.lockfile(Bundler.default_lockfile)
      builder.eval_gemfile(Bundler.default_gemfile)
      builder.dependencies = builder.dependencies.map do |dep|
        requirements.key?(dep.name) ? dep.with_requirement(requirements[dep.name]) : dep
      end

      definition = builder.to_definition(builder.lockfile_path, gems: requirements.keys)
      CLI::Common.configure_gem_version_promoter(definition, options)
      options[:local] ? definition.resolve_with_cache! : definition.resolve_remotely!
    end

    def plan_entry(name, current, target, pin)
      return { current: current, target: target, requirement: pin } if pin

      dep = direct_dependencies[name]
      requirement, warning = requirement_for(target, dep)
      # Nothing newer: still rewrite when an operator flag explicitly
      # requests a different requirement.
      return if target <= current && !(operator_flag && requirement_changed?(dep, requirement))

      { current: current, target: target, requirement: requirement, warning: warning }
    end

    def operator_flag
      OPERATOR_FLAGS.each_key.find {|flag| options[flag] }
    end

    def requirement_changed?(dep, requirement)
      Gem::Requirement.new(requirement).as_list != dep.requirement.as_list
    end

    # @return [Array(String, String)] the requirement to write and, when the
    #   declared requirement cannot be kept as it is, a warning.
    def requirement_for(target, dep)
      return ["#{OPERATOR_FLAGS[operator_flag]} #{target}", nil] if operator_flag

      preserve_operator(dep, target)
    end

    # Keeps the operator declared in the Gemfile. The declaration is read
    # from the source text, since a bare `"1.0"` and an explicit `"= 1.0"`
    # look the same once parsed.
    def preserve_operator(dep, target)
      declared = declared_requirements(dep)
      return ["~> #{target}", nil] if declared.empty?

      operator = declared.first[OPERATOR, 1]
      requirement, reason =
        case operator
        when nil then [target.to_s, nil]
        when "~>", ">=", "=" then ["#{operator} #{target}", nil]
        when ">" then [">= #{target}", "since `> #{target}` would exclude the resolved version"]
        else ["~> #{target}", "since ceilings cannot be preserved when moving to a newer version"]
        end
      reason ||= "since the other constraints cannot be preserved when moving to a newer version" if declared.size > 1

      [requirement, reason && "Rewriting `#{declared.join(", ")}` as `#{requirement}`, #{reason}."]
    end

    def declared_requirements(dep)
      GemfileRequirementRewriter.new(Bundler.read_file(dep.gemfile)).requirements_for(dep.name) || []
    end

    # The requirement as written in the Gemfile, e.g. `"> 1.0", "< 2.0"`.
    def gemfile_requirement(info)
      Array(info[:requirement]).map(&:dump).join(", ")
    end

    def confirm_interactive(plan)
      plan.reject do |name, info|
        # `ask` returns nil when stdin is not available (a script or CI run),
        # which stands for the default answer advertised by the prompt.
        answer = Bundler.ui.ask("Update #{name} from #{info[:current]} to #{info[:target]} (#{gemfile_requirement(info)})? (Y/n) ")
        answer.to_s.strip.casecmp?("n")
      end
    end

    def rewrite_gemfile(plan)
      missing = plan.keys - Injector.update_requirements(plan.transform_values {|info| info[:requirement] })
      return if missing.empty?

      raise GemfileError, "Could not find a `gem` declaration for #{missing.join(", ")} to rewrite. " \
        "Only declarations with a literal gem name and string requirements can be bumped, so update the requirement manually."
    end

    def install_updates(names)
      Bundler.definition(gems: names)
      CLI::Common.configure_gem_version_promoter(Bundler.definition, options)

      installer = Installer.install Bundler.root, Bundler.definition, options
      Bundler.load.cache if Bundler.app_cache.exist?

      if CLI::Common.clean_after_install?
        require_relative "clean"
        Bundler::CLI::Clean.new(options).run
      else
        CLI::Common.prune(options)
      end

      CLI::Common.output_post_install_messages installer.post_install_messages
      CLI::Common.output_cooldown_skipped_summary
      CLI::Common.output_fund_metadata_summary
    end

    # `bump` rewrites the Gemfile before installing, so a failed install would
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
      (Bundler.definition.gemfiles + [Bundler.default_lockfile]).to_h {|path| [path, File.read(path)] }
    end

    def restore_gemfiles(snapshot)
      snapshot.each {|path, contents| File.write(path, contents) }
    end

    def report(plan)
      specs = Bundler.definition.specs
      plan.each do |name, info|
        installed = specs[name].first.version
        if installed == info[:current]
          Bundler.ui.confirm "#{name} requirement updated to #{gemfile_requirement(info)} (already at #{info[:current]})"
        else
          Bundler.ui.confirm "#{name} updated from #{info[:current]} to #{installed}"
        end
      end
      Bundler.ui.confirm "Bundle bumped!"
      CLI::Common.output_without_groups_message(:update)
    end
  end
end
