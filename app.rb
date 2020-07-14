require 'sinatra'
require 'sinatra/json'

require 'maxmind/db'

configure do
  $maxmind_reader = MaxMind::DB.new(
    'db/GeoLite2-Country.mmdb',
    mode: MaxMind::DB::MODE_MEMORY
  )
end

get '/' do
  if params[:ip].nil? || params[:ip].empty?
    halt 200
  end

  geo_data = $maxmind_reader.get(params[:ip]) || {}

  json geo_data
rescue IPAddr::InvalidAddressError
  status 400
  json error: "Bad request: IP address '#{params[:ip]}' is not valid"
end

get '/country_code' do
  if params[:ip].nil? || params[:ip].empty?
    halt 200
  end

  geo_data = $maxmind_reader.get(params[:ip]) || {}

  json country_code: geo_data.dig('country', 'iso_code')
rescue IPAddr::InvalidAddressError
  status 400
  json error: "Bad request: IP address '#{params[:ip]}' is not valid"
end
