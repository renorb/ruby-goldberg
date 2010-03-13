require 'helper'

class TestReuben < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    RG::Reuben.new TestAdapter
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
    post "/rubeme", {:name => "test_rube", 
                     :desc => "I am some rube that does NOTHING", 
                     :url => "http://example.com/rube"}
                     
    assert_match /test_rube/, last_response.body
    assert_match /http:\/\/example.com\/rube/, last_response.body
    assert_match /does NOTHING/, last_response.body
  end

  def test_check_url_responds
    get "/check"
    assert last_response.ok?
  end

  def test_reuben_can_register_a_client
    post "/rubeme", {:name => "test_rube", :url => "http://example.com/rube", :desc => "I am another rube for tests."}
    get "/check?test_rube"
    assert_match /test_rube/, last_response.body
  end
end
