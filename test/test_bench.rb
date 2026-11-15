# frozen_string_literal: true

require "net/http"
require "stringio"
require "tmpdir"
require_relative "../tool/bench/run"
require_relative "rubygems/helper"

class BenchTest < Test::Unit::TestCase
  def test_gem_server_serves_index_entries_with_matching_checksums
    Dir.mktmpdir do |dir|
      index = File.join(dir, "index.txt")
      File.write(index, "a 1.0.0 b:>= 1&< 3|ruby:>= 3.0\nb 2.0.0\nb 2.0.0-x86_64-linux\n")
      server = Bench::GemServer.new(index, dir)
      uri = URI(server.start)

      Net::HTTP.start(uri.host, uri.port) do |http|
        versions = http.get("/versions").body
        assert_match(/^a 1\.0\.0 \h{32}$/, versions)
        assert_match(/^b 2\.0\.0,2\.0\.0-x86_64-linux \h{32}$/, versions)

        info = http.get("/info/a")
        assert_match(/\A---\n1\.0\.0 b:< 3&>= 1\|checksum:\h{64},ruby:>= 3\.0\n\z/, info.body)
        assert_equal "304", http.get("/info/a", "If-None-Match" => info["ETag"]).code

        gem = http.get("/gems/a-1.0.0.gem").body
        assert_equal Digest::SHA256.hexdigest(gem), info.body[/checksum:(\h+)/, 1]
        spec = Gem::Package.new(StringIO.new(gem)).spec
        assert_equal ["b", Gem::Requirement.new("< 3", ">= 1")], spec.runtime_dependencies.map {|d| [d.name, d.requirement] }.first
        assert_equal Gem::Requirement.new(">= 3.0"), spec.required_ruby_version

        assert_equal "404", http.get("/info/missing").code
      end
    ensure
      server&.shutdown
    end
  end

  def test_gem_server_reuses_its_cache
    Dir.mktmpdir do |dir|
      index = File.join(dir, "index.txt")
      File.write(index, "a 1.0.0\n")
      Bench::GemServer.new(index, dir)
      caches = Dir.children(dir).grep(/\Agem_server-\h+\.marshal\z/)
      assert_equal 1, caches.size

      File.write(index, "a 1.0.1\n")
      Bench::GemServer.new(index, dir)
      assert_equal 1, Dir.children(dir).grep(/\Agem_server-\h+\.marshal\z/).size
      assert_not_equal caches, Dir.children(dir).grep(/\Agem_server-\h+\.marshal\z/)
    end
  end

  def test_run_rejects_invalid_arguments_before_measuring
    assert_aborts_with(/at least 1/, "--iterations", "0")
    assert_aborts_with(/No selected command runs on rails: setup runs on large/, "--scenarios", "rails", "--commands", "setup")
    assert_aborts_with(/unique ignoring case/, "Head=#{Bench::ROOT}", "head=#{Bench::ROOT}")
    assert_aborts_with(/Invalid label/, "../x=#{Bench::ROOT}")
  end

  def test_median
    assert_equal 2.0, Bench.median([3, 1, 2])
    assert_equal 2.5, Bench.median([4, 1, 3, 2])
  end

  def test_probe_reports_allocations_when_the_process_exits
    omit "the probe reads GC counters that only CRuby has" unless RUBY_ENGINE == "ruby"

    Dir.mktmpdir do |dir|
      out = File.join(dir, "probe")
      env = { "RUBYLIB" => File.expand_path("../tool/bench", __dir__), "RUBYOPT" => "-rprobe", "BENCH_PROBE_OUT" => out }
      assert system(env, RbConfig.ruby, "-e", "1")
      assert_match(/\A\d+ \d*\n\z/, File.read(out))
    end
  end

  private

  def assert_aborts_with(message, *argv)
    stderr = $stderr
    $stderr = StringIO.new
    error = assert_raise(SystemExit) { Bench.run(argv) }
    assert_match message, error.message
  ensure
    $stderr = stderr
  end
end
