require 'rails_helper'

RSpec.describe Country, type: :model do

  describe '#create' do
    let(:ip) { '178.168.80.187' }
    it 'returns country info' do
      reader = MaxMind::DB.new(
        Rails.root.to_s + '/db/GeoLite2-Country.mmdb',
        mode: MaxMind::DB::MODE_MEMORY
      )
      country_geo_data = reader.get(ip)
      reader.close

      country = Country.new(ip)

      expect(country.geo_data).to include(country_geo_data)
    end
  end
end
