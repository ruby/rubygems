# frozen_string_literal: true

require_relative "helper"

class TestGemCoreExtTCPSocketInit < Gem::TestCase
  unless method_defined?(:assert_separately)
    require "core_assertions"
    include Test::Unit::CoreAssertions
  end

  def test_initialize_forwards_socket_arguments
    omit "assert_separately cannot run a child process on JRuby for Windows" if RUBY_ENGINE == "jruby" && Gem.win_platform?

    assert_separately [], <<~RUBY, ignore_stderr: true
      require "rubygems/core_ext/tcpsocket_init"
      require "stringio"

      class << Addrinfo
        undef_method :foreach
        def foreach(*)
          yield Struct.new(:ip_address, :ipv4?).new("2001:db8::1", false)
        end
      end

      class << Socket
        undef_method :tcp
        def tcp(*)
          StringIO.new
        end
      end

      class FakeSocket
        prepend CoreExtensions::TCPSocketExt::Initializer

        attr_reader :arguments

        def initialize(host, serv, local_host = nil, local_port = nil, open_timeout: nil)
          @arguments = [host, serv, local_host, local_port, open_timeout]
        end
      end

      socket = FakeSocket.new("example.test", 443, "::", 1234)
      assert_equal ["2001:db8::1", 443, "::", 1234, nil], socket.arguments

      socket = FakeSocket.new("example.test", 443, "::", 1234, open_timeout: 7)
      assert_equal ["2001:db8::1", 443, "::", 1234, 7], socket.arguments
    RUBY
  end
end
