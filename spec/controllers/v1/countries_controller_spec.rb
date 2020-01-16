require 'rails_helper'

require_relative '../shared_context/controller_helpers.rb'

RSpec.describe V1::CountriesController, type: :controller do
  include_context 'controller helpers'

  describe 'GET #show' do
    it 'destroys the requested client' do
      ip = '178.168.80.187'
      get :show, params: { ip: ip }

      reader = MaxMind::DB.new(
        Rails.root.to_s + '/db/GeoLite2-Country.mmdb',
        mode: MaxMind::DB::MODE_MEMORY
      )
      country = reader.get(ip)
      reader.close

      expect(response.status).to eq(200)
      expect(json_parsed(response.body)[:data]).to include(country)
    end
  end
end
