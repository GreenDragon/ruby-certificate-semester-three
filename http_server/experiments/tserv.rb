require 'socket' 
require 'time'
### 
# Server code 
# 
server = TCPServer.new(8080) 
while session = server.accept 
  Thread.new(session) do |my_session| 
    my_session.puts "Hello\n\r\n\r"
    my_session.close 
  end
end 
