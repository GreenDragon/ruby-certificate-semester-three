require 'socket'
require 'ipaddr'

class ChittyChattyBangBang
  VERSION = '1.0.0'

# snarked from 
# http://onestepback.org/index.cgi/Tech/Ruby/MulticastingInRuby.red


  MULTICAST_ADDR = "225.4.5.6"
  PORT = 7387

  attr_accessor :nick

  def initialize(nick)
    @nick = nick
  end

  def change_nick(nick)
    @nick = nick
  end

  def send_chat(message)
    begin
      socket = UDPSocket.open
      socket.setsockopt(Socket::IPPROTO_IP, Socket::IP_MULTICAST_TTL, [1].pack('i'))
      socket.send("\_\{#{@nick}\}\_: #{message}", 0, MULTICAST_ADDR, PORT)
    ensure
      socket.close
    end
  end

  def get_chits
    ip =  IPAddr.new(MULTICAST_ADDR).hton + IPAddr.new("0.0.0.0").hton

    sock = UDPSocket.new
    sock.setsockopt(Socket::IPPROTO_IP, Socket::IP_ADD_MEMBERSHIP, ip)
    sock.bind(Socket::INADDR_ANY, PORT)

    loop do
      msg, info = sock.recvfrom(1024)
      if msg =~ /^\_\{(.*)\}\_\:/ then
        nick = $1
      else
        nick = "UNKNOWN"
      end
      if msg =~ /^.*\}\_\: (.*)/ then
        chat = $1
      else
        chat = "Lost in Translation"
      end
      puts "#{nick}: \"#{chat}\" from: #{info[2]} (#{info[3]})/#{info[1]}"
    end
  end
end
