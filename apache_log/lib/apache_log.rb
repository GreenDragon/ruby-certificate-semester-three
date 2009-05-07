require 'thread'
require 'resolv'

class ApacheLog
  VERSION='1.0.0'

  attr_accessor :records_queue, :ipaddrs_queue, :domains_hash

  def initialize
    @records_queue = []
    @ipaddrs_queue = []
    @domains_hash = {}
  end

  def log_reader(filename)
    # handle bad file?
    open(filename, "r").each_line do |line|
      @records_queue << line.chomp
      if line =~ /^(\d*\.\d*\.\d*\.\d*)\s*/ then
        @ipaddrs_queue << $1 unless @ipaddrs_queue.include? $1
      end
    end
  end

  def getname(ipaddr)
    begin
      Resolv.getname(ipaddr)
    rescue
      "#{ipaddr}.unresolveable.tld"
    end
  end

  def resolver
    @ipaddrs_queue.each do |ipaddr|
      @domains_hash[ipaddr] = [getname(ipaddr), Time.now]
    end
  end

  # snarked from http://codesnippets.joyent.com/posts/show/1155
  def marshal(filename, mode="r")
    # Dir.chdir(TMP_DIR) do
    if mode == 'w' then
      open(filename, "w") { |f| Marshal.dump(@domains_hash, f) }
    elsif File.exists?(filename)
      open(filename, "r") { |f| Marshal.load(f) }
    end
    # end
  end

  def expire_stale_ipaddrs(expires)
    @domains_hash.delete_if { |k,v| ( ( Time.now - v[1] ) >= expires) }
  end

  def log_writer(file)
  end
end

# And the crack fantasy starts

@al = ApacheLog.new

limit = 1

mutex = Mutex.new

records = Queue.new
ip_addrs = Queue.new

threads = [
  Thread.new do
    mutex.synchronize {
      @al.log_reader("input.log", records, ip_addrs)
    }
  end,
  (1..limit).each do
    Thread.new do
      mutex.synchronize {
        @al.resolver(ip_addrs)
      }
    end
  end,
  Thread.new do
    mutex.synchronize {
      @al.log_writer("processed.log")
    }
  end
]
