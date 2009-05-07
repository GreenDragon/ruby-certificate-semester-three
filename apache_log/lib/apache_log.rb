require 'thread'
require 'resolv'

class ApacheLog
  VERSION='1.0.3'

  attr_accessor :records_q, :ipaddrs_q, :domains_hash

  def initialize
    @records_q = Queue.new
    @ipaddrs_q = Queue.new
    @domains_hash = {}
  end

  def log_reader(filename)
    # handle bad file?
    open(filename, "r").each_line do |line|
      @records_q << line.chomp
      # too clever? feels like dup code
      @ipaddrs_q << get_ipaddr(line) if get_ipaddr(line)
    end
  end

  def get_ipaddr(string)
    ipaddr = $1 if string =~ /^((\d{1,3}\.){3}\d{1,3})\s/
  end

  def getname(ipaddr)
    begin
      Resolv.getname(ipaddr)
    rescue
      "#{ipaddr}.unresolveable.tld"
    end
  end

  def resolver
    until @ipaddrs_q.empty? do
      ipaddr = @ipaddrs_q.shift
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
    # raise panic if @domains_hash.empty?
    # until @records_q.empty?
    #   line = @records_q.shift
    #   ipaddr = $1 if line =~ /^(\d*\.\d*\.\d*\.\d*\s*)/
    #   tld = domains_hash[ipaddr][0]
    #   s
    #   write line to file
    # end
  end
end

# And the crack fantasy starts

@al = ApacheLog.new

limit = 1

# mutex = Mutex.new zenspider sez not needed

records = Queue.new
ip_addrs = Queue.new

threads = [
  Thread.new do
    @al.log_reader("input.log")
  end,
  (1..limit).each do
    Thread.new do
      @al.resolver
    end
  end,
  Thread.new do
    @al.log_writer("processed.log")
  end
]
