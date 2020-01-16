require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Countries' do
  explanation 'Contain endpoints related to countries. '\
    'Includes operations like getting country info from client\'s request ip address'\

  authentication(
    :basic,
    :api_key,
    description: 'Provide client name and password as '\
      'basic auth credentials'
  )
  header 'Content-Type', 'application/json'

  let(:admin) { create(:client, :admin) }
  let(:api_key) {
    ActionController::HttpAuthentication::Basic.encode_credentials(
      admin.name,
      admin.api_key
    )
  }

  let(:json_response) { JSON.parse(response_body).with_indifferent_access }
  let(:data) { json_response[:data] }

  get '/v1/countries' do
    route_summary 'Get country info from an IP address'
    route_description 'Every users can reach this endpoint get country info from an IP address.'

    with_options with_example: true do
      parameter :ip, 'Request ip address', required: true
    end

    context '200' do
      let(:ip) { '178.168.80.18' }

      example 'Country info' do
        reader = MaxMind::DB.new(
          Rails.root.to_s + '/db/GeoLite2-Country.mmdb',
          mode: MaxMind::DB::MODE_MEMORY
        )
        country_info = reader.get(ip)
        reader.close
        do_request

        expect(data).to eq(country_info)
        expect(status).to eq(200)
      end
    end

    context '404' do
      let(:ip) { 'invalid' }

      example 'Bad request' do
        do_request

        expect(status).to eq(400)
        expect(json_response).to include(error: 'Invalid IP address')
      end
    end
  end
end
