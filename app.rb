require 'sinatra'
require 'sinatra/json'

require 'maxmind/db'

configure do
  $maxmind_reader = MaxMind::DB.new(
    'db/GeoLite2-Country.mmdb',
    mode: MaxMind::DB::MODE_MEMORY
  )
end

# You can ask on the root path which will return
# the fully detailed response from MaxMind
get '/' do
  if params[:ip].nil? || params[:ip].empty?
    halt 200, { message: "I'm ok! Please ask me about an IP address." }.to_json
  end

  response = $maxmind_reader.get(params[:ip]) || {}

  json response
rescue IPAddr::InvalidAddressError
  status 422
  json error: "Invalid IP address #{params[:ip]}"
end

# You can ask more detailed for the country code
get '/country_code' do
  if params[:ip].nil? || params[:ip].empty?
    halt 422, { 'Content-Type' => 'application/json' }, { error: 'Missing IP address' }.to_json
  end

  geo_data = $maxmind_reader.get(params[:ip]) || {}

  response = { country_code: geo_data.dig('country', 'iso_code') }

  json response
rescue IPAddr::InvalidAddressError
  status 422
  json error: "Invalid IP address #{params[:ip]}"
end
