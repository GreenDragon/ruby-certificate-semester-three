require 'thread'
require 'resolv'
require 'tmpdir'

class ApacheLog
  VERSION='1.0.4'

  MAX_THREADS = 5
  MAX_CACHE_AGE = (24 * 60 * 60)
  TIMEOUT = 15.0
  IP_REGEX  = /^((\d{1,3}\.){3}\d{1,3})\s*/

  attr_accessor :records_q, :ipaddrs_q, :domains_hash, :num_threads, :write_q
  attr_accessor :log_file, :cache_db

  def initialize(threads = MAX_THREADS, age = MAX_CACHE_AGE, timeout = TIMEOUT )
    @records_q = Queue.new
    @ipaddrs_q = Queue.new
    @domains_hash = {}
    @write_q = []
    @mutex = Mutex.new
    @log_file = ''
    @cache_db = "domains.db"
    #
    @num_threads = threads
    @cache_age = age
    @timeout = timeout
  end

  def log_reader
    # handle bad file?
    open(@log_file, "r").each_line do |line|
      @records_q << line.chomp
      @ipaddrs_q << get_ipaddr(line) if get_ipaddr(line)
    end
  end

  def get_ipaddr(string)
    string.match(IP_REGEX)[1]
  end

  def getname(ipaddr)
    begin
      timeout(@timeout) { Resolv.getname(ipaddr) }
    rescue Timeout::Error, Resolv::ResolvError, Resolv::ResolvTimeout
      "#{ipaddr}.unresolveable.tld"
    end
  end

  def resolve_names
    @mutex.synchronize do
      until @ipaddrs_q.empty? do
        ipaddr = @ipaddrs_q.shift
        unless @domains_hash.has_key? ipaddr
          @domains_hash[ipaddr] = [getname(ipaddr), Time.now]
        end
      end
    end
  end

  def save_cache
    Dir.chdir(Dir::tmpdir) do
      open(@cache_db, "w") { |f| Marshal.dump(@domains_hash, f) }
    end
  end

  def load_cache
    Dir.chdir(Dir::tmpdir) do
      if File.exist?(@cache_db)
        open(@cache_db, "r") { |f| Marshal.load(f) } if File.exists?(@cache_db)
      end
    end
  end
        
  def expire_stale_ipaddrs(expires = @cache_age)
    @domains_hash.delete_if { |k,v| ( ( Time.now - v[1] ) >= expires) }
  end

  def run
    load_cache
    expire_stale_ipaddrs
    log_reader
    resolvers = []
    (1..@num_threads).each do |thread|
      resolvers << Thread.new do
        resolve_names
      end
    end
    resolvers.each { |r| r.join }
    save_cache
  end

  def log_writer
    raise ArgumentError, "Missing Domain Lookup Hash" if @domains_hash.empty?
    raise ArgumentError, "Missing Records Array" if @records_q.empty?
    until @records_q.empty?
      line = @records_q.shift
      ipaddr = get_ipaddr(line)
      name = @domains_hash[ipaddr][0]
      line.gsub!(/^#{ipaddr}/, name)
      @write_q << line
    end
    File.open(@log_file + ".translated", 'w') do |f|
      @write_q.each { |line| f.puts line }
    end
  end
end
