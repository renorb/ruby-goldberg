require "rubygems"
require "test/unit"
require "rack/test"

require 'reuben'
require 'reuben/adapters/memcached_adapter'


class TestReuben < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Rack::Reuben.new Reuben::Adapters::MemcachedAdapter, 'localhost:11211'
  end

  def test_root_url_responds
    get "/"
    assert last_response.ok?
  end

  def test_returns_the_reuben_index
    get "/"
    assert_match /Reuben/, last_response.body
  end

  def test_rubeme_url_refuses_get
    get"/rubeme"
    assert !last_response.ok?
  end

  def test_rubeme_can_accept_client_params
    post "/rubeme", {:name => "test_rube", :rube => "http://example.com/rube", :health => "http://example.com/knock_knock"}
    # "registered name:#{name} rube url:#{rube} health url:#{health}"
    assert_match /test_rube/, last_response.body
    assert_match /http:\/\/example.com\/rube/, last_response.body
    assert_match /http:\/\/example.com\/knock_knock/, last_response.body
  end

  def test_check_url_responds
    get "/check"
    assert last_response.ok?
  end

  def test_reuben_can_register_a_client
    post "/rubeme", {:name => "test_rube", :rube => "http://example.com/rube", :health => "http://example.com/knock_knock"}
    get "/check?test_rube"
    assert_match /test_rube/, last_response.body
  end
end
