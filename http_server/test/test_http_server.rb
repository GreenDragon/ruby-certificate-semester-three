require "test/unit"
require "redgreen"
require "http_server"
require "time"
require "socket"
require "open-uri"

# snarked from http://snippets.dzone.com/posts/show/1738

class Time
  class <<self
    attr_accessor :testing_offset
    alias_method :real_now, :now

    def now
      real_now - testing_offset
    end

    alias_method :new, :now
  end
end

Time.testing_offset = 0

class TestHttpServer < Test::Unit::TestCase
  def setup
    @crlf = "\n\r\n\r"
    @time = Time.now.httpdate

    @server = HttpServer.new
    @threads = []

    # warn name
  end

  def test_prepare_request
    @server.prepare_request("/index.html")

    actual = @server.request
    expected = "GET /index.html HTTP/0.9#{@crlf}"

    assert_equal expected, actual
  end

  def test_default_header
    @server.build_header(0)
 
    actual = @server.header
    expected = "HTTP/0.9 200 OK#{@crlf}" +
    "Date: #{@time}#{@crlf}" +
    "Last-Modified: #{@time}#{@crlf}" +
    "Content-Length: 0#{@crlf}" +
    "Content-Type: text/html#{@crlf}" +
    "#{@crlf}"

    assert_equal expected, actual
  end

  def test_http_server_debug_basedir
    actual = @server.debug
    assert_match(/^BASEDIR.*\/root$/, actual)
  end

  def test_http_server_answers
    @threads << Thread.new do
      @server.start
    end
    
    session = TCPSocket.new('localhost', 8080)
    actual = session.read
    session.close

    assert_equal "Hello#{@crlf}", actual
  end
end
