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

# end snark

class TestHttpServer < Test::Unit::TestCase
  def setup
    @crlf = "\n\r"
    @now = Time.now.httpdate

    @response = HttpServer::Response.new
    @server = HttpServer.new
    @util = HttpServer::Util.new

    @threads = []

    @raw = "GET / HTTP/0.9#{@crlf}" <<
            "Host: localhost#{@crlf}" <<
            "Date: #{@now}#{@crlf}#{@crlf}"

    # warn name
  end

  def test_prepare_request
    actual = @util.prepare_request("/index.html")
    expected = "GET /index.html HTTP/0.9" + @crlf

    assert_equal expected, actual
  end

  def test_prepare_request_adds_default_path
    actual = @util.prepare_request
    expected = "GET / HTTP/0.9" + @crlf

    assert_equal expected, actual
  end

  def test_parse_request
    req = @util.prepare_request("/index.html")

    @request = HttpServer::Request.new(req)

    assert_equal "GET",           @request.method
    assert_equal "/index.html",   @request.path
    assert_equal "0.9",           @request.protocol
  end

  def test_parse_request_headers
    @request = HttpServer::Request.new(@raw)

    assert_equal @request.headers, {
      "Host" => "localhost",
      "Date" => @now
    }
  end

  def test_response_defaults
    assert_nil @response.body
    assert_equal 200, @response.status
    assert_equal Hash.new, @response.headers
  end

  def test_response_header_200
    actual = @response.content
    expected =  "HTTP/0.9 200 OK" + @crlf +
                "Date: #{@now}" + @crlf +
                "Allow: GET" + @crlf +
                "Last-Modified: #{@now}" + @crlf +
                "Content-Length: 0" + @crlf +
                "Content-Type: text/html" + @crlf +
                "#{@crlf}"

    assert_equal expected, actual
  end

  def test_response_header_404
    @response.status = 404
    
    actual = @response.content
    expected =  "HTTP/0.9 404 Not Found" + @crlf +
                "Date: #{@now}" + @crlf +
                "Allow: GET" + @crlf +
                @crlf +
                "Your file was so big." + @crlf +
                "It might be very useful."  + @crlf +
                "But now it is gone." + @crlf

    assert_equal expected, actual
  end

  def test_response_header_500
    @response.status = 500
    
    actual = @response.content
    expected =  "HTTP/0.9 500 Internal Server Error" + @crlf +
                "Date: #{@now}" + @crlf +
                "Allow: GET" + @crlf +
                @crlf +
                "<p>Something <strong>Wicked</strong> This Way Went</p>"
  end

  def test_response_header_302
    @response.status = 302
    @response.redirect = "/redirected.erb"

    actual = @response.content
    expected =  "HTTP/0.9 302 Found" + @crlf +
                "Date: #{@now}" + @crlf +
                "Allow: GET" + @crlf +
                "Location: http://localhost:8080/redirected.erb" + @crlf

    assert_equal expected, actual
  end

  #def test_http_server_debug_basedir
  #  actual = @server.debug
  #  assert_match(/^BASEDIR.*\/root$/, actual)
  #end

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
