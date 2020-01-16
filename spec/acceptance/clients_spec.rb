require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Clients' do
  explanation 'Contain endpoints related to clients. '\
    'Includes operations like registering a new client in the GeoIP service '\
    'and getting information about a registered client.'

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
  let(:expected_response) {
    {
      'id' => kind_of(Integer),
      'name' => kind_of(String),
      'role' => kind_of(String),
      'api_key' => kind_of(String)
    }
  }

  get '/v1/clients/:name' do
    route_summary 'Get registered client details'
    route_description 'Only admin users can reach this endpoint to get token '\
      'for already registered client.'

    let!(:test_client) { create(:client) }

    context '200' do
      let(:name) { test_client.name }

      example 'Сlient\'s details' do
        do_request

        expect(status).to eq(200)
        expect(data).to match(expected_response)
      end
    end

    context '404' do
      let(:name) { 'nonexisting' }

      example 'Client not found' do
        do_request

        expect(status).to eq(404)
        expect(json_response).to include(error: 'Record not found')
      end
    end

    context '401' do
      let(:admin) { create(:client) }
      let(:name) { test_client.name }

      example 'Unauthorized access' do
        do_request

        expect(status).to eq(401)
        expect(json_response).to include(error: 'Unauthorized access')
      end
    end
  end

  post '/v1/clients' do
    route_summary 'Registered a new client'
    route_description 'Only admin users can reach this endpoint to register '\
      'a new client in GeoIP system.'

    with_options scope: :data, with_example: true do
      parameter :name, 'Short company name', required: true
    end

    let(:test_client) { attributes_for(:client) }
    let(:name) { test_client[:name] }

    let(:raw_post) { params.to_json }

    context '201' do
      example 'Client created' do
        do_request

        expect(status).to eq(201)
        expect(data).to match(expected_response)
      end
    end

    context '422' do
      before do
        create(:client, name: test_client[:name])
      end

      example 'Client not created' do
        do_request

        expect(status).to eq(422)
        expect(json_response).to include({
          error: 'Validation failed',
          details: ['Name has already been taken']
        })
      end
    end

    context '401' do
      let(:admin) { create(:client) }

      example 'Unauthorized access' do
        do_request

        expect(status).to eq(401)
        expect(json_response).to include(error: 'Unauthorized access')
      end
    end
  end

  delete '/v1/clients/:name' do
    route_summary 'Delete an existing client'
    route_description 'Completely remove client with all it\'s data from the '\
      'system. Only admin users can reach this endpoint.'

    let!(:test_client) { create(:client) }

    context '204' do
      let(:name) { test_client.name }

      example 'Client deleted' do
        do_request

        expect(status).to eq(204)
      end
    end

    context '404' do
      let(:name) { 'nonexisting' }

      example 'Client not deleted' do
        do_request

        expect(status).to eq(404)
        expect(json_response).to include(error: 'Record not found')
      end
    end

    context '401' do
      let(:admin) { create(:client) }
      let(:name) { test_client.name }

      example 'Unauthorized access' do
        do_request

        expect(status).to eq(401)
        expect(json_response).to include(error: 'Unauthorized access')
      end
    end
  end
end
