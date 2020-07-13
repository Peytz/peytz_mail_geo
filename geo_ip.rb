require 'sinatra'
require 'maxmind/db'
require './models/country.rb'
require 'pry'

configure do
  $maxmind_reader = MaxMind::DB.new(
    'GeoLite2-Country.mmdb',
    mode: MaxMind::DB::MODE_MEMORY
  )
end

get '/' do
  @country = Country.new(params[:ip])
  geo_data = @country.geo_data
  
  if geo_data.nil?
    raise ActiveRecord::RecordNotFound
  else
    geo_data.to_json
  end
end
