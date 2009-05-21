require "test/unit"
require "chitty_chatty_bang_bang"
require "redgreen"
require "stringio"
# require 'pp'

#module Kernel
#  def capture_stdout
#    out = StringIO.new
#    $stdout = out
#    yield
#    $stdout = STDOUT
#    return out
#  end
#end

# from gem utility_belt
# puts "some string" | "cowsay"

class String
  def |(cmd)
    IO.popen(cmd, 'r+') do |pipe|
      pipe.write(self)
      pipe.close_write
      pipe.read
    end
  end
end

class TestChittyChattyBangBang < Test::Unit::TestCase
  def setup
    @chatty = ChittyChattyBangBang.new("dragon")
    @threads = []
  end

  def test_can_change_nick
    @chatty.change_nick("whoops")
    assert_equal "whoops", @chatty.nick
  end

  # GARRR WTFFFFFFF!!!!!
  # <#<StringIO:0x50de80>> expected to be =~
  # </Yo DAWG/>.
  # HULK SMASH THIS MOFO!!!!
  # WAAAHHHH!!!!
  #def test_can_send_message
  #  expected = capture_stdout do
  #    @threads << Thread.new do
  #      @chatty.get_chits
  #    end
  #  end
  #  @threads << Thread.new do
  #    @chatty.send_chat("Yo DAWG?")
  #  end
  #  @threads.each { |t| t.exit }
  #  @threads.each { |t| t.join }

  #  expected.each_line do |wtf|
  #    pp wtf
  #  end
  #  pp @threads

  #  assert_match(/Yo DAWG/, expected)
  #end
end
