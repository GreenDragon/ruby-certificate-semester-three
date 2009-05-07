require "test/unit"
require "apache_log"
require "redgreen"
require "time"
require "pp"

class TestApacheLog < Test::Unit::TestCase
  def setup
    @parser = ApacheLog.new

    @records = []
    @ipaddrs = []
    @lookups = {}
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

  def test_log_reader_parses_file
    @parser.log_reader("test.log")
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

  def test_resolver_converts_ipaddrs_array
    @parser.log_reader("test.log")
    assert_equal @parser.ipaddrs_q.size, 12
    assert_equal @parser.records_q.size, 12
    @parser.resolver
    assert_equal @parser.domains_hash.map { |k,v| [ k, v[0] ] }.sort, [
  ["208.77.188.166", "www.example.com"],
  ["74.125.67.100", "gw-in-f100.google.com"],
  ["75.119.201.189", "apache2-moon.legs.dreamhost.com"],
  ["75.146.57.34", "greed.zenspider.com"]
]
  end

  def test_marshalling_domain_name_lookups
    @parser.log_reader("test.log")
    @parser.resolver
    File.delete("domains.db") if File.exist?("domains.db")
    @parser.marshal("domains.db", "w")
    actual = @parser.marshal("domains.db")

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
end
