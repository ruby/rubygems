# frozen_string_literal: true

require "digest"
require "fileutils"
require "socket"
require "stringio"
require "rubygems/package"
require_relative "../../spec/support/vendored_compact_index"

module Bench
  # Serves the compact index snapshot in index.txt (see update_index.rb) with
  # fake gems in place of the real ones. The gems hold a single empty file and
  # no extensions, so only Bundler's own work shows up in measurements.
  class GemServer
    # Building the fake gems takes seconds, so the responses are cached in
    # cache_dir for each combination of index, server code and Ruby.
    def initialize(index, cache_dir)
      key = Digest::SHA256.hexdigest([File.read(index), File.read(__FILE__), RUBY_DESCRIPTION].join("\0"))
      cache = File.join(cache_dir, "gem_server-#{key}.marshal")
      if File.exist?(cache)
        @responses = Marshal.load(File.binread(cache))
      else
        build(index)
        FileUtils.mkdir_p(cache_dir)
        Dir.children(cache_dir).grep(/\Agem_server-\h+\.marshal\z/) {|name| File.delete(File.join(cache_dir, name)) }
        File.binwrite(cache, Marshal.dump(@responses))
      end
    end

    def start
      @server = TCPServer.new("127.0.0.1", 0)
      @port = @server.addr[1]
      @thread = Thread.new do
        until @stopping
          client = @server.accept
          @stopping ? client.close : Thread.new(client) {|c| serve(c) }
        end
      ensure
        # Closing on every exit, a failed accept included, makes the measured
        # command fail at once instead of waiting on a socket nobody accepts.
        @server.close
      end
      "http://127.0.0.1:#{@port}"
    end

    # Closing the socket from another thread does not wake a blocked accept on
    # every Ruby (TruffleRuby on Linux hung here), so a connection wakes it.
    def shutdown
      return unless @thread
      @stopping = true
      TCPSocket.new("127.0.0.1", @port).close
    rescue SystemCallError
      # the accept loop has already stopped and closed the socket
    ensure
      @thread&.join
    end

    private

    def build(index)
      @responses = {}
      lines = specs_from(index).group_by(&:name).map do |name, specs|
        versions = specs.sort_by {|s| [s.version, s.platform.to_s] }.map do |spec|
          gem = build_gem(spec)
          add_response("/gems/#{spec.file_name}", gem)
          deps = spec.runtime_dependencies.map {|d| VendoredCompactIndex::Dependency.new(d.name, d.requirement.as_list.join(", ")) }
          VendoredCompactIndex::GemVersionV2.new(spec.version.to_s, spec.platform.to_s, Digest::SHA256.hexdigest(gem), nil, deps,
            spec.required_ruby_version.as_list.join(", "), spec.required_rubygems_version.as_list.join(", "))
        end
        info = VendoredCompactIndex.info(versions)
        add_response("/info/#{name}", info)
        "#{name} #{versions.map(&:version_token).join(",")} #{Digest::MD5.hexdigest(info)}\n"
      end
      add_response("/versions", "created_at: 2026-01-01T00:00:00Z\n---\n#{lines.sort.join}")
    end

    def specs_from(index)
      # File.foreach without a block passes chomp: on as a line limit on JRuby.
      entries = File.readlines(index, chomp: true).map do |line|
        name, token, rest = line.split(" ", 3)
        version, platform = token.split("-", 2)
        deps, requirements = rest.to_s.split("|", 2)
        requirements = requirements.to_s.split(",").to_h {|r| r.split(":", 2) }
        [name, version, platform, deps.to_s.split(",").map {|d| d.split(/[:&]/) }, requirements["ruby"]&.split("&"), requirements["rubygems"]&.split("&")]
      end

      # The resolver may pick the running Ruby's default gems over the indexed
      # versions, and without them in the index those get no checksum, which
      # frozen installs reject. rubygems.org has them, so serve them too.
      indexed = entries.to_set {|name, version| [name, version] }
      Gem::Specification.default_stubs.map(&:to_spec).each do |spec|
        next if spec.name == "bundler" || indexed.include?([spec.name, spec.version.to_s])
        entries << [spec.name, spec.version.to_s, nil, spec.runtime_dependencies.map {|d| [d.name, *d.requirement.as_list] }, nil, nil]
      end

      entries.map do |name, version, platform, deps, ruby, rubygems|
        Gem::Specification.new do |s|
          s.name = name
          s.version = version
          s.platform = platform if platform
          s.summary = "Fake gem for tool/bench"
          s.authors = ["tool/bench"]
          s.files = ["lib/#{name}.rb"]
          s.required_ruby_version = ruby if ruby
          s.required_rubygems_version = rubygems if rubygems
          deps.each {|dep| s.add_runtime_dependency(*dep) }
        end
      end
    end

    # Gem::Package#build would sign with the default key in ~/.gem if present.
    def build_gem(spec)
      data = tar {|t| add_file(t, spec.files.first, "") }
      tar do |t|
        add_file(t, "metadata.gz", Gem::Util.gzip(spec.to_yaml))
        add_file(t, "data.tar.gz", Gem::Util.gzip(data))
      end
    end

    def tar
      io = StringIO.new("".b)
      Gem::Package::TarWriter.new(io) {|t| yield t }
      io.string
    end

    def add_file(tar, name, content)
      tar.add_file_simple(name, 0o644, content.bytesize) {|io| io.write(content) }
    end

    def add_response(path, body)
      etag = %("#{Digest::MD5.hexdigest(body)}")
      head = "HTTP/1.1 200 OK\r\nContent-Length: #{body.bytesize}\r\nETag: #{etag}\r\n" \
             "Repr-Digest: sha-256=:#{Digest::SHA256.base64digest(body)}:\r\n\r\n"
      @responses[path] = [etag, head.b + body.b]
    end

    # Range requests get the full body, which the compact index client accepts.
    def serve(client)
      while (request_line = client.gets)
        path = request_line.split(" ", 3)[1]
        if_none_match = nil
        while (line = client.gets) && line != "\r\n"
          name, value = line.split(":", 2)
          if_none_match = value.strip if name.casecmp?("If-None-Match")
        end

        etag, response = @responses[path]
        client.write(if !response
          "HTTP/1.1 404 Not Found\r\nContent-Length: 0\r\n\r\n"
        elsif if_none_match == etag
          "HTTP/1.1 304 Not Modified\r\nETag: #{etag}\r\n\r\n"
        else
          response
        end)
      end
    rescue Errno::ECONNRESET, Errno::EPIPE
      # the client went away mid-request
    ensure
      client.close
    end
  end
end
