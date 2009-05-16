require 'time'
require 'fileutils'
require 'socket'
require 'erb'
require 'thread'
require 'gserver'

module HttpServer
  VERSION = '1.0.0'

  PROTOCOL_VERSION = 'HTTP/0.9'
  PORT = 8080
  
  METHODS = [ "GET" ]
  
  CRLF="\n\r"

  class Conductor
    @@servlets ||= {}

    attr_accessor :redirects, :doc_root

    def initialize(doc_root=FileUtils.pwd() + "/root")
      @redirects ||= {}
      @doc_root = doc_root
    end

    def get_servlet_proc(string)
      @@servlets[string]
    end

    def call_servlet(string)
      @@servlets[string].call
    end

    def register(path, &block)
      raise ArgumentError, "Servlet requires a block"  unless block_given?
      raise ArgumentError, "Path requires ^/" unless path.match(/^\/.*/)
      @@servlets[path] = block
    end

    def set_redirect(path, newpath)
      redirects[path] = newpath
    end

    def build_body(request)
      response = Response.new
      if @@servlets[request.path]
        servlet_track(response, request.path)
      elsif @redirects[request.path]
        redirect_track(response, @redirects[request.path])
      else
        if request.path =~ /\.erb$/i
          erb_track(response, request.path)
        else
          static_track(response, request.path)
        end
      end
      response
    end

  private
  
    def servlet_track(response, path)
      begin
        response.body = @@servlets[path].call
      rescue Exception => e
        response.status = 500
        response.body = "Fail Whale Summoned!" << e.inspect
      end
    end

    def redirect_track(response, new_path)
      raise ArgumentError, "Path requires ^/" unless new_path.match(/^\/.*/)
      response.status = 302
      response.redirect = new_path
    end

    def erb_track(response, path)
      begin
        content = File.read("#{doc_root}#{path}")
        erb = ERB.new(content).src
        response.body = eval(erb, binding)
      rescue Errno::ENOENT => e
        response.status = 404
      rescue Exception => e
        response.status = 500
        response.body = "Fail Whale Summoned!" << e.inspect
      end
    end

    def static_track(response, path)
      begin
        File.open("#{doc_root}#{path}", "r") do |f|
          response.body = f.read
        end
      rescue Errno::ENOENT => e
        response.status = 404
      end
    end
  end

  class Response
    attr_accessor :body, :redirect, :status

    @@statuses = {
      200 => "OK",
      302 => "Found",
      404 => "Not Found",
      500 => "Internal Server Error"
    }

    def initialize
      @body = nil
      @redirect = nil
      @status = 200
    end

    def get_content
      q = ""
      q << header_string(@status) << HttpServer::CRLF
      q << "Date: #{Time.now.httpdate}" << HttpServer::CRLF
      q << "Allow: #{HttpServer::METHODS.join(',')}" << HttpServer::CRLF

      case @status
      when 200
        q << "Last-Modified: #{Time.now.httpdate}" << HttpServer::CRLF
        if @body.nil? then
          q << "Content-Length: 0" << HttpServer::CRLF
        else
          q << "Content-Length: #{@body.size}" << HttpServer::CRLF
        end
        q << "Content-Type: text/html" << HttpServer::CRLF
        q << HttpServer::CRLF
        q << @body unless @body.nil?
      when 302
        q << "Location: http://localhost:#{HttpServer::PORT}#{@redirect}" 
        q << HttpServer::CRLF
      when 404
        q << "Content-Type: text/html" << HttpServer::CRLF
        q << HttpServer::CRLF
        q << "Your file was so big." << HttpServer::CRLF
        q << "It might be very useful." << HttpServer::CRLF
        q << "But now it is gone." << HttpServer::CRLF
      when 500
        q << "Content-Type: text/html" << HttpServer::CRLF
        q << HttpServer::CRLF
        q << "<p>Something <strong>Wicked</strong> This Way Went</p>"
      else
        raise "Unsupported Status Code #{@status}"
      end
      q
    end
  
  private

    def header_string(status)
      "#{HttpServer::PROTOCOL_VERSION} #{status} #{@@statuses[status]}"
    end
  end

  class Request
    attr_accessor :method, :path, :protocol, :headers

    def initialize(request)
      @headers = {}
      parse(request)
    end

  private

    def parse(request)
      request.each_line do |line|
        break if line == HttpServer::CRLF
        line.strip!
        if line =~ /^(\w+) (\/.*) HTTP\/(\d+\.\d+)/ then
          @method, @path, @protocol = $1, $2, $3
        elsif line =~ /^(.+): (.+)/
          @headers[$1] = $2
        end
      end
      @path = '/index.html' if @path.match(/^\/$/)
    end
  end

  class Util
    def prepare_get_request(string="/")
      "GET #{string} " + HttpServer::PROTOCOL_VERSION + HttpServer::CRLF
    end
  end
end


class HttpGServer < GServer
  include HttpServer

  def initialize(port=HttpServer::PORT, *args)
    super(port, *args)
  end

  def serve(io)
    @conductor = HttpServer::Conductor.new
    @request = HttpServer::Request.new(read_uri(io))
    @response = @conductor.build_body(@request)
    io.puts(@response.get_content)
  end

private

  def read_uri(io)
    raw_request = ""
    io.each_line do |line|
      break if line == "\r\n"
      raw_request << line
    end
    raw_request
  end
end

class HttpTCPServer
  include HttpServer

  def initialize(port=HttpServer::PORT, max_threads=5)
    @port = port
    @max_threads = max_threads
  end

  def start
    threads = ThreadGroup.new
    server = TCPServer.new(@port)
    while session = server.accept
      if threads.list.size <= @max_threads
        thread = Thread.new(session) do |this_session|
          @conductor = HttpServer::Conductor.new
          req = this_session.gets
          @request = HttpServer::Request.new(req)
          @response = @conductor.build_body(@request)
          this_session.write @response.get_content
          this_session.close
        end
        threads.add(thread)
      end
    end
  end
end
