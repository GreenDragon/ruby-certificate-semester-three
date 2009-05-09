require "test/unit"
require "apache_log"
require "redgreen"
require "time"
require "tmpdir"

class TestApacheLog < Test::Unit::TestCase
  def setup
    @parser = ApacheLog.new

    @test_log = "test.log"
    @translated_log = "test.log.translated"
    @domains_db = "domains.db"

    @parser.log_file = @test_log
    @parser.cache_db = @domains_db
  end

  def test_get_ipaddr
    string = "208.77.188.166 - - [29/Apr/2009:16:07:38 -0700] \"GET / HTTP/1.1\" 200 1342"
    
    actual = @parser.get_ipaddr(string)
    expected = "208.77.188.166"
    
    assert_equal expected, actual
  end

  def test_getname_resolve_ipaddr_to_fqdn
    host1 = @parser.getname('76.121.96.144')
    host2 = @parser.getname('64.22.71.237')

    assert_equal host1, "c-76-121-96-144.hsd1.wa.comcast.net"
    assert_equal host2, "ns1.arashi.com"
  end

  def test_getname_handles_unknown_reverse_lookups
    host1 = @parser.getname('127.0.0.66')

    assert_equal host1, "127.0.0.66.unresolveable.tld"
  end

  def test_log_reader_carps_on_bad_files
    @parser.log_file = "bogus.log"
    assert_raise ArgumentError do
      @parser.log_reader
    end
  end

  def test_log_reader_parses_file
    @parser.log_reader
    actual_records, actual_ipaddrs = [], []
    actual_records << @parser.records_q.shift until @parser.records_q.empty?
    actual_ipaddrs << @parser.ipaddrs_q.shift until @parser.ipaddrs_q.empty?
    actual_ipaddrs.sort!.uniq!
    assert_equal actual_records, [
"208.77.188.166 - - [29/Apr/2009:16:07:38 -0700] \"GET / HTTP/1.1\" 200 1342",
"75.119.201.189 - - [29/Apr/2009:16:07:44 -0700] \"GET /favicon.ico HTTP/1.1\" 200 1406",
"75.146.57.34 - - [29/Apr/2009:16:08:38 -0700] \"GET / HTTP/1.1\" 304 -",
"75.119.201.189 - - [29/Apr/2009:16:09:53 -0700] \"GET / HTTP/1.1\" 200 1340",
"208.77.188.166 - - [29/Apr/2009:16:11:51 -0700] \"GET / HTTP/1.1\" 304 -",
"75.146.57.34 - - [29/Apr/2009:16:12:00 -0700] \"GET / HTTP/1.1\" 304 -",
"75.119.201.189 - - [29/Apr/2009:16:13:15 -0700] \"GET / HTTP/1.1\" 304 -",
"208.77.188.166 - - [29/Apr/2009:16:13:15 -0700] \"GET / HTTP/1.1\" 304 -",
"75.119.201.189 - - [29/Apr/2009:16:13:17 -0700] \"GET / HTTP/1.1\" 304 -",
"75.146.57.34 - - [29/Apr/2009:16:13:50 -0700] \"GET / HTTP/1.1\" 200 1294",
"75.146.57.34 - - [29/Apr/2009:16:13:55 -0700] \"GET /stylesheets/main.css?1240264242 HTTP/1.1\" 200 2968",
"74.125.67.100 - - [29/Apr/2009:16:13:55 -0700] \"GET /stylesheets/home.css?1240264242 HTTP/1.1\" 200 7829"
    ]
    assert_equal actual_ipaddrs, [
"208.77.188.166", "74.125.67.100", "75.119.201.189", "75.146.57.34"
    ]
  end

# fragile!
# ["75.119.201.189", "apache2-moon.legs.dreamhost.com"]
# ["75.119.201.189", "75.119.201.189.unresolveable.tld"]

  def test_resolver_converts_ipaddrs_array
    @parser.log_reader
    assert_equal @parser.ipaddrs_q.size, 12
    assert_equal @parser.records_q.size, 12
    @parser.resolve_names
    assert_equal @parser.domains_hash.map { |k,v| [ k, v[0] ] }.sort, [
  ["208.77.188.166", "www.example.com"],
  ["74.125.67.100", "gw-in-f100.google.com"],
  ["75.119.201.189", "apache2-moon.legs.dreamhost.com"],
  ["75.146.57.34", "greed.zenspider.com"]
]
  end

  def test_marshalling_domain_name_lookups
    @parser.log_reader
    @parser.resolve_names
    Dir.chdir(Dir::tmpdir) do
      File.delete(@domains_db) if File.exist?(@domains_db)
    end
    @parser.save_cache
    actual = @parser.load_cache

    assert_equal @parser.domains_hash, actual
  end

  def test_expire_domains_from_lookups
    @parser.domains_hash = {
      "208.77.188.166"  => [ "www.example.com", Time.now],
      "74.125.67.100"   => [ "gw-in-f100.google.com", Time.parse("Wed May 06 19:00:00 -0700 2009") ],
      "75.119.201.189"  => [ "apache2-moon.legs.dreamhost.com", Time.now],
      "75.146.57.34"    => [ "greed.zenspider.com", Time.parse("Wed May 06 19:00:00 -0700 2009") ]
    }

    actual = @parser.expire_stale_ipaddrs(60)

    assert_equal [
      ["208.77.188.166", "www.example.com"],
      ["75.119.201.189", "apache2-moon.legs.dreamhost.com"]
    ], actual.map { |k,v| [ k, v[0] ] }.sort
  end

  def test_expire_domains_from_lookups_with_default_max_age
    @parser.domains_hash = {
      "208.77.188.166"  => [ "www.example.com", Time.now],
      "74.125.67.100"   => [ "gw-in-f100.google.com", Time.parse("Wed May 06 19:00:00 -0700 2009") ],
      "75.119.201.189"  => [ "apache2-moon.legs.dreamhost.com", Time.now],
      "75.146.57.34"    => [ "greed.zenspider.com", Time.parse("Wed May 06 19:00:00 -0700 2009") ]
    }

    actual = @parser.expire_stale_ipaddrs
    assert_equal [
      ["208.77.188.166", "www.example.com"],
      ["75.119.201.189", "apache2-moon.legs.dreamhost.com"]
    ], actual.map { |k,v| [ k, v[0] ] }.sort
  end

  def test_run_results
    @parser.run

    expected = [
      ["208.77.188.166", "www.example.com"],
      ["74.125.67.100", "gw-in-f100.google.com"],
      ["75.119.201.189", "apache2-moon.legs.dreamhost.com"],
      ["75.146.57.34", "greed.zenspider.com"]
    ]

    actual = @parser.domains_hash.map { |k,v| [ k, v[0] ] }.sort

    assert_equal expected, actual
  end

  def test_log_writer_fails_if_missing_domains_cache
    @parser.domains_hash = {}
    assert_raise ArgumentError do
      @parser.log_writer
    end
  end

  def test_log_writer_fails_if_missing_records_queue
    @parser.records_q = []
    assert_raise ArgumentError do
      @parser.log_writer
    end
  end

  def test_log_writer_creates_proper_array
    @parser.run
    @parser.log_writer
    actual = @parser.write_q
    expected = [
"www.example.com - - [29/Apr/2009:16:07:38 -0700] \"GET / HTTP/1.1\" 200 1342",
"apache2-moon.legs.dreamhost.com - - [29/Apr/2009:16:07:44 -0700] \"GET /favicon.ico HTTP/1.1\" 200 1406",
"greed.zenspider.com - - [29/Apr/2009:16:08:38 -0700] \"GET / HTTP/1.1\" 304 -",
"apache2-moon.legs.dreamhost.com - - [29/Apr/2009:16:09:53 -0700] \"GET / HTTP/1.1\" 200 1340",
"www.example.com - - [29/Apr/2009:16:11:51 -0700] \"GET / HTTP/1.1\" 304 -",
"greed.zenspider.com - - [29/Apr/2009:16:12:00 -0700] \"GET / HTTP/1.1\" 304 -",
"apache2-moon.legs.dreamhost.com - - [29/Apr/2009:16:13:15 -0700] \"GET / HTTP/1.1\" 304 -",
"www.example.com - - [29/Apr/2009:16:13:15 -0700] \"GET / HTTP/1.1\" 304 -",
"apache2-moon.legs.dreamhost.com - - [29/Apr/2009:16:13:17 -0700] \"GET / HTTP/1.1\" 304 -",
"greed.zenspider.com - - [29/Apr/2009:16:13:50 -0700] \"GET / HTTP/1.1\" 200 1294",
"greed.zenspider.com - - [29/Apr/2009:16:13:55 -0700] \"GET /stylesheets/main.css?1240264242 HTTP/1.1\" 200 2968",
"gw-in-f100.google.com - - [29/Apr/2009:16:13:55 -0700] \"GET /stylesheets/home.css?1240264242 HTTP/1.1\" 200 7829"
    ]

    assert_equal expected, actual
  end

  def test_log_writer_creates_file
    File.delete(@translated_log) if File.exists?(@translated_log)
    @parser.run
    @parser.log_writer
    assert ! File.identical?(@test_log, @translated_log)
  end
end
