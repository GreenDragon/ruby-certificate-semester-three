require 'time'
require 'fileutils'
require 'socket'

class HttpServer
  VERSION = '1.0.0'

  PROTOCOL_VERSION = 'HTTP/0.9'
  PORT = 8080
  
  METHODS = [ "GET" ]
  
  CRLF="\n\r"

  class Response
    attr_accessor :body, :redirect, :status, :headers

    @@status = {
      200 => "OK",
      302 => "Found",
      404 => "Not Found",
      500 => "Internal Server Error"
    }

    def initialize
      @body = nil
      @redirect = nil
      @status = 200
      @headers = {}
    end

    def content
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
        q << HttpServer::CRLF
        q << "Your file was so big." << HttpServer::CRLF
        q << "It might be very useful." << HttpServer::CRLF
        q << "But now it is gone." << HttpServer::CRLF
      when 500
        q << HttpServer::CRLF
        q << "<p>Something <strong>Wicked</strong> This Way Went</p>"
      else
        raise "Unsupported Status Code #{@status}"
      end
      q
    end
  
  private

    def header_string(status)
      "#{HttpServer::PROTOCOL_VERSION} #{status} #{@@status[status]}"
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
        line.strip!
        if line =~ /^(\w+) (\/.*) HTTP\/(\d+\.\d+)/ then
          @method, @path, @protocol = $1, $2, $3
        elsif line =~ /^(.+): (.+)/
          @headers[$1] = $2
        end
      end
    end
  end

  class Util
    def prepare_request(string="/")
      "GET #{string} " + HttpServer::PROTOCOL_VERSION + HttpServer::CRLF
    end
  end
    
  #def initialize
  #  @header = ""
  #  @basedir = FileUtils.pwd() + "/root"
  #end

  def start
    server = TCPServer.new('localhost',PORT)
    while session = server.accept
      session.write "Hello#{CRLF}"
      session.close
    end
  end

  #def debug
  #  "BASEDIR: " + @basedir
  #end
end
