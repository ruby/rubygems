#!/usr/bin/env ruby
# frozen_string_literal: true

# Measures Bundler and RubyGems commands of one or more checkouts against a
# local fake gem server and prints median wall time, CPU time, allocated
# objects and, on Linux, peak RSS. The first checkout is the baseline of the
# ratio columns. It needs Ruby 3.3 or later, which some gems the large
# scenario pins require.
#
#   ruby tool/bench/run.rb                            # this checkout
#   ruby tool/bench/run.rb base=../rubygems head=.    # compare two checkouts
#   ruby tool/bench/run.rb --scenarios large --commands setup,exec

require "fileutils"
require "json"
require "optparse"
require "rbconfig"
require "time"
require_relative "gem_server"

module Bench
  ROOT = File.expand_path("../..", __dir__)
  WORK = File.join(ROOT, "tmp/bench")
  SCENARIOS = File.join(__dir__, "scenarios")
  INDEX = File.join(__dir__, "index.txt")

  # The caller's Ruby, RubyGems, Bundler and XDG settings (RUBYOPT=-w,
  # RUBY_YJIT_ENABLE, GEM_HOME, BUNDLE_USER_CONFIG and the like) would change
  # what is measured, so none of them reach the measured process.
  def self.clean_env
    ENV.keys.grep(/\A(?:RUBY|BUNDLE|GEM|XDG_)/).to_h {|key| [key, nil] }
  end

  Target = Struct.new(:label, :root) do
    def revision
      IO.popen(["git", "-C", root, "rev-parse", "--short", "HEAD"], err: File::NULL, &:read).chomp
    rescue SystemCallError
      nil
    end
  end

  # Indexed gems that each scenario lacks, which the add command appends to its Gemfile.
  ADDED_GEMS = { "rails" => "sidekiq", "large" => "kamal" }.freeze

  # clean: paths removed from the workspace before each run.
  # env: :bundle, :frozen (bundle with BUNDLE_FROZEN) or :gem (GEM_HOME on the installed bundle).
  # args: passed to ruby -I <checkout>/lib, with exe/ resolved in the checkout.
  # add_gem: run with ADDED_GEMS in the Gemfile, after one unmeasured run that installs it.
  Command = Struct.new(:name, :scenarios, :iterations, :clean, :env, :args, :add_gem)

  INSTALL = Command.new("install-cold", %w[rails large], 5, %w[vendor .bundle Gemfile.lock home], :bundle, %w[exe/bundle install])

  COMMANDS = [
    INSTALL,
    Command.new("install-warm", %w[rails large], 5, %w[vendor .bundle], :frozen, %w[exe/bundle install]),
    Command.new("lock", %w[rails large], 10, %w[Gemfile.lock], :bundle, %w[exe/bundle lock]),
    Command.new("update", %w[rails large], 10, [], :bundle, %w[exe/bundle update --all]),
    Command.new("setup", %w[large], 10, [], :bundle, %w[-rbundler/setup -e 1]),
    Command.new("exec", %w[large], 10, [], :bundle, ["exe/bundle", "exec", RbConfig.ruby, "-e", "1"]),
    Command.new("require", %w[large], 10, [], :gem, ["-e", 'File.read("Gemfile").scan(/^gem "([^"]+)"/) { require $1 }']),
    Command.new("gem-list", %w[large], 10, [], :gem, %w[exe/gem list]),
    Command.new("boot", %w[large], 10, [], :gem, %w[-e 1]),
    Command.new("add", %w[rails large], 10, [], :bundle, %w[exe/bundle install], true),
  ].freeze

  # One checkout's copy of a scenario. Everything a measured process reads or
  # writes, HOME and every cache included, stays under its directory.
  class Workspace
    attr_reader :target

    def initialize(target, scenario, source)
      @target = target
      @dir = File.join(WORK, target.label, scenario)
      FileUtils.rm_rf(@dir)
      FileUtils.mkdir_p(@dir)
      @gemfile = File.read(File.join(SCENARIOS, "#{scenario}.rb")).sub('source "https://rubygems.org"', %(source "#{source}"))
      @added_gem = ADDED_GEMS.fetch(scenario)
    end

    # Every command after install-cold starts from the lockfile it wrote, so
    # that no command depends on what the one before it left behind. add runs
    # last because the gem it adds stays installed.
    def ensure_installed
      measure(INSTALL) unless File.exist?(path("Gemfile.lock")) && Dir.exist?(path("vendor"))
      FileUtils.cp(path("Gemfile.lock"), path("installed.lock")) unless File.exist?(path("installed.lock"))
    end

    def measure(command)
      FileUtils.cp(path("installed.lock"), path("Gemfile.lock")) if File.exist?(path("installed.lock"))
      command.clean.each {|name| FileUtils.rm_rf(path(name)) }
      FileUtils.mkdir_p(path("home"))
      File.write(path("Gemfile"), command.add_gem ? %(#{@gemfile}gem "#{@added_gem}"\n) : @gemfile)
      File.write(path("probe"), "")
      argv = [RbConfig.ruby, "-I", File.join(@target.root, "lib"), *command.args.map {|a| a.start_with?("exe/") ? File.join(@target.root, a) : a }]

      before = Process.times
      start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      pid = Process.spawn(env(command.env), *argv, chdir: @dir, out: path("log"), err: [:child, :out])
      _, status = Process.wait2(pid)
      wall = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
      after = Process.times
      abort "#{command.name} failed for #{@target.label}, the output is in #{path("log")}" unless status.success?

      probes = File.readlines(path("probe")).map(&:split)
      rss = probes.filter_map {|_, kb| kb&.to_i }.max
      {
        wall: wall,
        # Windows reports no CPU time for child processes.
        cpu: (after.cutime + after.cstime - before.cutime - before.cstime unless Gem.win_platform?),
        alloc: probes.sum {|alloc, _| alloc.to_i },
        rss: rss && rss / 1024.0,
      }
    end

    private

    def path(name)
      File.join(@dir, name)
    end

    def env(kind)
      env = Bench.clean_env
      # Ruby splits RUBYOPT on spaces, so the probe's directory goes through RUBYLIB.
      env.merge!("HOME" => path("home"), "RUBYLIB" => __dir__, "RUBYOPT" => "-rprobe", "BENCH_PROBE_OUT" => path("probe"))
      if kind == :gem
        gem_home = File.join(path("vendor/bundle"), RUBY_ENGINE, RbConfig::CONFIG["ruby_version"])
        env.merge!("GEM_HOME" => gem_home, "GEM_PATH" => gem_home)
      else
        env.merge!("BUNDLE_GEMFILE" => path("Gemfile"), "BUNDLE_PATH" => path("vendor/bundle"), "BUNDLE_JOBS" => "8", "BUNDLE_RETRY" => "0")
        env["BUNDLE_FROZEN"] = "true" if kind == :frozen
      end
      env
    end
  end

  def self.median(values)
    sorted = values.sort
    (sorted[(sorted.size - 1) / 2] + sorted[sorted.size / 2]) / 2.0
  end

  def self.run(argv)
    options = { out: File.join(WORK, "results.json") }
    OptionParser.new do |opts|
      opts.banner = "Usage: ruby tool/bench/run.rb [options] [[LABEL=]CHECKOUT ...]"
      opts.on("--scenarios LIST", Array, "Scenarios to run (default: all)") {|v| options[:scenarios] = v }
      opts.on("--commands LIST", Array, "Commands to run (default: all)") {|v| options[:commands] = v }
      opts.on("--iterations N", Integer, "Runs per command (default: 5 for installs, 10 otherwise)") {|v| options[:iterations] = v }
      opts.on("--out FILE", "Where to write the JSON results (default: tmp/bench/results.json)") {|v| options[:out] = v }
    end.parse!(argv)
    abort "--iterations must be at least 1" if options[:iterations] && options[:iterations] < 1

    all_scenarios = COMMANDS.flat_map(&:scenarios).uniq
    unknown = (options[:scenarios] || []) - all_scenarios
    abort "Unknown scenarios: #{unknown.join(", ")}. Available: #{all_scenarios.join(", ")}" unless unknown.empty?
    unknown = (options[:commands] || []) - COMMANDS.map(&:name)
    abort "Unknown commands: #{unknown.join(", ")}. Available: #{COMMANDS.map(&:name).join(", ")}" unless unknown.empty?

    commands = COMMANDS.select {|c| options[:commands].nil? || options[:commands].include?(c.name) }
    scenarios = commands.flat_map(&:scenarios).uniq & (options[:scenarios] || all_scenarios)
    if scenarios.empty?
      abort "No selected command runs on #{options[:scenarios].join(", ")}: #{commands.map {|c| "#{c.name} runs on #{c.scenarios.join(", ")}" }.join(", ")}"
    end

    targets = (argv.empty? ? [ROOT] : argv).map do |arg|
      label, root = arg.include?("=") ? arg.split("=", 2) : [nil, arg]
      root = File.expand_path(root)
      abort "#{root} is not a RubyGems checkout" unless File.exist?(File.join(root, "lib/bundler.rb"))
      label ||= File.basename(root)
      # The label names a directory under tmp/bench that gets removed.
      abort "Invalid label #{label.inspect}, use letters, digits, '.', '_' and '-'" unless label.match?(/\A\w[\w.-]*\z/)
      Target.new(label, root)
    end
    # Case-insensitive file systems would put Head and head in one directory.
    unless targets.map {|t| t.label.downcase }.uniq.size == targets.size
      abort "Checkout labels must be unique ignoring case, name them with LABEL=CHECKOUT"
    end
    abort "tool/bench needs Ruby 3.3 or later, which some gems the large scenario pins require" if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("3.3")

    server = GemServer.new(INDEX, WORK)
    source = server.start
    $stdout.sync = true
    row = "%-9s %-13s %-#{[5, *targets.map {|t| t.label.size }].max}s %9s %9s %12s %8s %9s %9s %9s"
    print_row = ->(*cols) { puts format(row, *cols, *[""] * (10 - cols.size)).rstrip }
    number = ->(value, digits = 3) { value ? format("%.#{digits}f", value) : "-" }
    print_row.call("scenario", "command", "label", "wall(s)", "cpu(s)", "alloc", "rss(MB)", *(["wall/1st", "alloc/1st", "rss/1st"] if targets.size > 1))
    results = []

    scenarios.each do |scenario|
      workspaces = targets.map {|t| Workspace.new(t, scenario, source) }
      commands.each do |command|
        next unless command.scenarios.include?(scenario)
        workspaces.each(&:ensure_installed) unless command == INSTALL

        workspaces.each {|w| w.measure(command) } if command.add_gem
        runs = workspaces.to_h {|w| [w, []] }
        # Alternating the order keeps drift on the machine from favoring one checkout.
        (options[:iterations] || command.iterations).times do |i|
          (i.even? ? workspaces : workspaces.reverse).each {|w| runs[w] << w.measure(command) }
        end

        baseline = nil
        runs.each do |w, samples|
          medians = [:wall, :cpu, :alloc, :rss].to_h do |key|
            values = samples.map {|s| s[key] }
            [key, values.all? ? median(values) : nil]
          end
          baseline ||= medians
          ratios = [:wall, :alloc, :rss].map {|key| number.call(medians[key] && baseline[key] && medians[key] / baseline[key]) } unless w == workspaces.first
          print_row.call(scenario, command.name, w.target.label, number.call(medians[:wall]), number.call(medians[:cpu]), medians[:alloc].round, number.call(medians[:rss], 1), *ratios)
          results << { scenario: scenario, command: command.name, label: w.target.label, runs: samples }
        end
      end
    end

    report = {
      ruby: IO.popen(clean_env, [RbConfig.ruby, "-e", "print RUBY_DESCRIPTION"], &:read),
      time: Time.now.utc.iso8601,
      targets: targets.map {|t| { label: t.label, root: t.root, revision: t.revision } },
      results: results,
    }
    FileUtils.mkdir_p(File.dirname(options[:out]))
    File.write(options[:out], JSON.pretty_generate(report))
    puts "Results written to #{options[:out]}"
  ensure
    server&.shutdown
  end
end

Bench.run(ARGV) if $PROGRAM_NAME == __FILE__
