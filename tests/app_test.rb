require 'test/unit'
require 'rack/test'
require_relative '../app'

set :environment, :test

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  TEST_GOOD_IP = '77.233.245.14'.freeze
  TEST_BAD_IP = 'bad.ip.address.here'.freeze

  def app
    Sinatra::Application
  end

  def test_health_check
    get '/'

    assert last_response.ok?
    assert last_response.body.include?("I'm ok")
  end

  def test_country_code_by_ip_with_invalid_ip
    get '/country_code', ip: TEST_BAD_IP

    assert_equal last_response.status, 422
    assert_equal JSON.parse(last_response.body), {
      'error' => "Invalid IP address #{TEST_BAD_IP}"
    }
  end

  def test_country_code_by_ip
    reader = MaxMind::DB.new(
      'db/GeoLite2-Country.mmdb',
      mode: MaxMind::DB::MODE_MEMORY
    )
    get '/country_code', ip: TEST_GOOD_IP

    country = reader.get(TEST_GOOD_IP)
    reader.close

    assert last_response.ok?
    assert_equal(
      country['registered_country']['iso_code'],
      JSON.parse(last_response.body)['country_code']
    )
  end

  def test_detailed_lookup_by_ip
    reader = MaxMind::DB.new(
      'db/GeoLite2-Country.mmdb',
      mode: MaxMind::DB::MODE_MEMORY
    )
    country = reader.get(TEST_GOOD_IP)
    reader.close

    get '/', ip: TEST_GOOD_IP

    assert last_response.ok?
    assert_equal(country, JSON.parse(last_response.body))
  end
end
