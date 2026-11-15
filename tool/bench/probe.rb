# frozen_string_literal: true

# Loaded through RUBYOPT into every process tool/bench/run.rb measures. Appends
# the number of objects the process allocated, and its peak RSS in kB where
# Linux reports it, to BENCH_PROBE_OUT when it exits, or before it replaces
# itself as `bundle exec` does.
module BenchProbe
  def self.report
    rss = File.read("/proc/self/status")[/^VmHWM:\s*(\d+)/, 1] if File.exist?("/proc/self/status")
    File.write(ENV["BENCH_PROBE_OUT"], "#{GC.stat(:total_allocated_objects)} #{rss}\n", mode: "a")
  end

  module Exec
    def exec(...)
      BenchProbe.report
      super(...)
    end
  end
end

Kernel.singleton_class.prepend(BenchProbe::Exec)
at_exit { BenchProbe.report }

# Ruby installed by mise ships a rubygems_plugin.rb that shells out to
# `mise reshim` after every install unless this module is already defined.
module ReshimInstaller
  def self.reshim
  end
end
