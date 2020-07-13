require './geo_ip'
require 'test/unit'
require 'rack/test'

set :environment, :test

class GeoIpTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_country_by_ip
    ip = '178.168.80.187'
    reader = MaxMind::DB.new(
      'GeoLite2-Country.mmdb',
      mode: MaxMind::DB::MODE_MEMORY
    )
    get("/", params={ ip: ip })
    
    country = reader.get(ip)
    reader.close

    assert last_response.ok?
    assert_equal country, JSON.parse(last_response.body)
  end
end
