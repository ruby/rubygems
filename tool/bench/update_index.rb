#!/usr/bin/env ruby
# frozen_string_literal: true

# Snapshots from rubygems.org the compact index that tool/bench serves into
# index.txt, so that the resolver faces real version histories offline. It
# keeps the newest VERSIONS versions and the locked ones of every gem in the
# scenario lockfiles and of everything they depend on. Bundler is left out
# because a dependency on it always resolves to the running Bundler.
#
#   ruby tool/bench/update_index.rb

require "net/http"
require "rubygems"

VERSIONS = 30

locked = Hash.new {|h, k| h[k] = [] }
Dir.glob(File.join(__dir__, "scenarios/*.rb.lock")).each do |lockfile|
  File.foreach(lockfile) do |line|
    locked[$1] << $2 if line =~ /\A {4}(\S+) \(([^-)]+)/
  end
end

queue = locked.keys
index = {}
Net::HTTP.start("rubygems.org", 443, use_ssl: true) do |http|
  until queue.empty?
    name = queue.shift
    next if index.key?(name) || name == "bundler"

    response = http.get("/info/#{name}")
    abort "Fetching /info/#{name} failed with #{response.code}" unless response.is_a?(Net::HTTPOK)

    lines = response.body.lines(chomp: true).drop_while {|l| l != "---" }.drop(1)
    numbers = lines.map {|l| l[/\A[^ -]+/] }.uniq.sort_by {|v| Gem::Version.new(v) }
    keep = numbers.last(VERSIONS) | locked[name]
    index[name] = lines.select {|l| keep.include?(l[/\A[^ -]+/]) }.map do |line|
      version, rest = line.split(" ", 2)
      deps, requirements = rest.split("|", 2)
      queue.concat(deps.split(",").map {|d| d[/\A[^:]+/] })
      requirements = requirements.split(",").grep(/\A(?:ruby|rubygems):/)
      line = "#{name} #{version} #{deps}"
      requirements.empty? ? line.rstrip : "#{line}|#{requirements.join(",")}"
    end
  end
end

File.write(File.join(__dir__, "index.txt"), index.sort.flat_map(&:last).join("\n") << "\n")
puts "#{index.size} gems, #{index.sum {|_, lines| lines.size }} versions"
