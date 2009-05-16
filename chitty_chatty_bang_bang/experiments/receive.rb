#!/opt/local/bin/ruby -w

require 'socket'
require 'ipaddr'

MULTICAST_ADDR = "225.4.5.6" 

PORT = 7387

ip =  IPAddr.new(MULTICAST_ADDR).hton + IPAddr.new("0.0.0.0").hton

sock = UDPSocket.new
sock.setsockopt(Socket::IPPROTO_IP, Socket::IP_ADD_MEMBERSHIP, ip)
sock.bind(Socket::INADDR_ANY, PORT)

loop do
  msg, info = sock.recvfrom(1024)
  nick = msg.match(/^\_\{(.*)\}\_\:/)[1]
  chat = msg.match(/^.*\}\_\: (.*)/)[1]
  puts "#{nick}: \"#{chat}\" from: #{info[2]} (#{info[3]})/#{info[1]}"
end
