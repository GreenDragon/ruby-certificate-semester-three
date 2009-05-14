require 'time'
require 'fileutils'
require 'socket'

class HttpServer
  VERSION = '1.0.0'
  HTTP_VER='HTTP/0.9'
  HTTP_PORT=8080
  CRLF="\n\r\n\r"

  attr_accessor :request, :header, :time
  
  def initialize
    @request = ""
    @header = ""
    @basedir = FileUtils.pwd() + "/root"
  end

  def start
    server = TCPServer.new('localhost',HTTP_PORT)
    while session = server.accept
      session.write "Hello#{CRLF}"
      session.close
    end
  end

  def prepare_request(string)
    @request = "GET #{string} #{HTTP_VER}#{CRLF}"
  end

  def get(request)
    prepare_request(request)
  end

  def build_header(size=0, status="200 OK", type="text/html", last_mod=Time.now.httpdate)
    @header = "#{HTTP_VER} #{status}#{CRLF}" +
    "Date: #{Time.now.httpdate}#{CRLF}" + 
    "Last-Modified: #{last_mod}#{CRLF}" +
    "Content-Length: #{size}#{CRLF}" +
    "Content-Type: #{type}#{CRLF}" +
    "#{CRLF}"
  end

  def debug
    "BASEDIR " + @basedir
  end
end
