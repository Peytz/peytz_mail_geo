require './app'
require 'test/unit'
require 'rack/test'
require 'pry'

set :environment, :test

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_country_info_by_ip
    ip = '178.168.80.187'
    wrong_ip = 'wrong_ip'
    
    reader = MaxMind::DB.new(
      'GeoLite2-Country.mmdb',
      mode: MaxMind::DB::MODE_MEMORY
    )
    get('/', params={ ip: ip })
    
    country = reader.get(ip)
    reader.close

    assert last_response.ok?
    assert_equal country, JSON.parse(last_response.body)
    
    get('/', params={ ip: wrong_ip })
    
    assert_equal last_response.status, 400
    assert_equal JSON.parse(last_response.body), {
      'error' => "Bad request: IP address 'wrong_ip' is not valid"
    }
  end
  
  def test_country_code_by_ip
    ip = '178.168.80.187'
    wrong_ip = 'wrong_ip'
    
    reader = MaxMind::DB.new(
      'GeoLite2-Country.mmdb',
      mode: MaxMind::DB::MODE_MEMORY
    )
    get('/country_code', params={ ip: ip })
    
    country = reader.get(ip)
    reader.close

    assert last_response.ok?
    assert_equal(
      country['registered_country']['iso_code'],
      JSON.parse(last_response.body)['country_code']
    )
    
    get('/country_code', params={ ip: wrong_ip })
    
    assert_equal last_response.status, 400
    assert_equal(
      JSON.parse(last_response.body),
      {'error' => "Bad request: IP address 'wrong_ip' is not valid"}
    )
  end
end
