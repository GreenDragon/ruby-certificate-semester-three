require "test/unit"
require "redgreen"
require "http_server"
require "time"
require "socket"
require "open-uri"
require "pp"

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

def start_tcp_server
  @threads << Thread.new do
    @tcp_server.start
  end
end

# end snark

class TestHttpServer < Test::Unit::TestCase
  def setup
    @crlf = "\n\r"
    @now = Time.now.httpdate

    @conductor = HttpServer::Conductor.new
    @response = HttpServer::Response.new

    @tcp_server = HttpTCPServer.new
    @g_server = HttpGServer.new

    @util = HttpServer::Util.new

    @threads = []

    @raw = "GET / HTTP/0.9#{@crlf}" <<
            "Host: localhost#{@crlf}" <<
            "Date: #{@now}#{@crlf}#{@crlf}"

    @index_html = "http://127.0.0.1:8080/index.html"
    @index_erb = "http://127.0.0.1:8080/index.html.erb"

    # warn name
  end

  def test_prepare_get_request
    actual = @util.prepare_get_request("/index.html")
    expected = "GET /index.html HTTP/0.9" + @crlf

    assert_equal expected, actual
  end

  def test_prepare_get_request_adds_default_path
    actual = @util.prepare_get_request
    expected = "GET / HTTP/0.9" + @crlf

    assert_equal expected, actual
  end

  def test_parse_request_sanitizes_slash
    @request = HttpServer::Request.new('GET / HTTP/0.9' + @crlf*2)

    assert_equal "GET",           @request.method
    assert_equal "/index.html",   @request.path
    assert_equal "0.9",           @request.protocol
  end

  def test_parse_request
    req = @util.prepare_get_request("/index.html")

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
  end

  def test_response_header_200
    actual = @response.get_content
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
    
    actual = @response.get_content
    expected =  "HTTP/0.9 404 Not Found" + @crlf +
                "Date: #{@now}" + @crlf +
                "Allow: GET" + @crlf +
                "Content-Type: text/html" + @crlf +
                @crlf +
                "Your file was so big." + @crlf +
                "It might be very useful."  + @crlf +
                "But now it is gone." + @crlf

    assert_equal expected, actual
  end

  def test_response_header_500
    @response.status = 500
    
    actual = @response.get_content
    expected =  "HTTP/0.9 500 Internal Server Error" + @crlf +
                "Date: #{@now}" + @crlf +
                "Allow: GET" + @crlf +
                "Content-Type: text/html" + @crlf +
                @crlf +
                "<p>Something <strong>Wicked</strong> This Way Went</p>"

    assert_equal expected, actual
  end

  def test_response_header_302
    @response.status = 302
    @response.redirect = "/redirected.erb"

    actual = @response.get_content
    expected =  "HTTP/0.9 302 Found" + @crlf +
                "Date: #{@now}" + @crlf +
                "Allow: GET" + @crlf +
                "Location: http://localhost:8080/redirected.erb" + @crlf

    assert_equal expected, actual
  end

  def test_http_server_default_root_dir
    @conductor = HttpServer::Conductor.new
    actual = @conductor.doc_root
    assert_match(/^\/.*\/root$/, actual)
  end

  def test_conductor_servlet_requires_block
    assert_raises ArgumentError do
      @conductor.register "/time"
    end
  end

  def test_conductor_servlet_requires_rooted_path
    assert_raises ArgumentError do
      @conductor.register "time" do
        "epic fail"
      end
    end
  end

  def test_conductor_creates_and_serves_servlet
    @conductor.register "/time" do
      "The time is now #{Time.now}"
    end
    actual = @conductor.get_servlet_proc("/time")
    assert_instance_of(Proc, actual)
    
    expected = @conductor.call_servlet("/time")

    assert_equal "The time is now #{Time.now}", expected
  end

  def test_conductor_carps_on_bad_servlet
    @conductor.register "/epic_fail" do
      raise "Epic FAIL"
    end

    req = @util.prepare_get_request("/epic_fail")
    @request = HttpServer::Request.new(req)
    @response = @conductor.build_body(@request)

    assert_equal @response.status, 500
    assert_match(/Fail Whale Summoned/, @response.body)
  end

  def test_conductor_serves_index_html
    req = @util.prepare_get_request("/index.html")
    @request = HttpServer::Request.new(req)
    @response = @conductor.build_body(@request)

    assert_equal @response.status, 200

    actual = @response.body
    assert_match(/This is a <strong>test<\/strong>/, actual)
  end

  def test_conductor_carps_on_missing_file
    req = @util.prepare_get_request("/missing.html")
    @request = HttpServer::Request.new(req)
    @response = @conductor.build_body(@request)

    assert_equal @response.status, 404
  end

  def test_conductor_serves_index_html_erb
    req = @util.prepare_get_request("/index.html.erb")
    @request = HttpServer::Request.new(req)
    @response = @conductor.build_body(@request)

    assert_equal @response.status, 200

    assert_match(/Ten Thosand Times/, @response.body)
  end

  def test_conductor_carps_on_missing_index_html_erb
    req = @util.prepare_get_request("/missing.html.erb")
    @request = HttpServer::Request.new(req)
    @response = @conductor.build_body(@request)

    assert_equal @response.status, 404
  end

  def test_conductor_carps_when_erb_content_bad
    req = @util.prepare_get_request("/bad.erb")
    @request = HttpServer::Request.new(req)
    @response = @conductor.build_body(@request)

    assert_equal @response.status, 500
    assert_match(/Fail Whale Summoned/, @response.body)

    sanity = @response.get_content
  end

  def test_tcp_http_server_serves_index
    start_tcp_server
    actual = open(@index_html) { |f| f.read }
    
    assert_match(/This is a <strong>test/, actual)
  end

  # frakken churning on this one
  # 
  #def test_tcp_http_server_carps_on_missing_file
  #  start_tcp_server
  #  assert_throws OpenURI::HTTPError do  
  #    actual = open(@index_html + ".bad") { |f| f.read }
  #  end
  #end

  def test_tcp_http_server_serves_erb
    start_tcp_server
    actual = open(@index_erb) { |f| f.read }

    assert_match(/Ten Thosand Times/, actual)
  end

  def test_tcp_http_server_serves_servlet
    @conductor.register "/time" do
      "The time is now homework time: #{@now}"
    end

    start_tcp_server
    
    actual = open("http://127.0.0.1:8080/time") { |f| f.read }

    assert_match(/The time is now homework time: #{@now}/, actual)
  end

  def test_g_server_serves_index
    @g_server.start
    actual = open(@index_html) { |f| f.read }
    
    assert_match(/This is a/, actual)
    @g_server.shutdown
  end

  # and the clock is frakking ticking tick tock TICK TOCK
end
