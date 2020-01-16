require 'rails_helper'

require_relative '../shared_context/controller_helpers.rb'

RSpec.describe V1::ClientsController, type: :controller do
  include_context 'controller helpers'

  # Authorize as admin
  let(:current_client) { create(:client, :admin) }

  let(:valid_attrs) { attributes_for(:client) }

  describe 'GET #show' do
    it 'returns a client' do
      client = Client.create! valid_attrs

      get :show, params: { name: client.name }

      expect(response).to be_successful
      expect(json_parsed(response.body)[:data]).to include(
        name: client.name,
        role: client.role,
        api_key: client.api_key
      )
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Client' do
        expect {
          post :create, params: { data: valid_attrs }
        }.to change(Client, :count).by(1)
      end

      it 'renders a JSON response with the new client' do
        post :create, params: { data: valid_attrs }

        expect(response).to have_http_status(:created)
        expect(json_parsed(response.body)[:data]).to include(
          id: a_kind_of(Integer),
          name: valid_attrs[:name],
          role: 'client',
          api_key: a_kind_of(String)
        )
      end
    end

    context 'when name is taken' do
      it 'renders a JSON response with errors for the new client' do
        Client.create! valid_attrs
        post :create, params: { data: valid_attrs }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_parsed(response.body)).to include(
          error: 'Validation failed',
          details: ['Name has already been taken']
        )
      end
    end

    context 'with blank name' do
      let(:invalid_attrs) do
        valid_attrs[:name] = ''
        valid_attrs
      end

      it 'renders a JSON response with errors for the new client' do
        post :create, params: { data: invalid_attrs }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_parsed(response.body)).to include(
          error: 'Validation failed',
          details: ['Name can\'t be blank']
        )
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested client' do
      client = Client.create! valid_attrs

      expect {
        delete :destroy, params: { name: client.name }
      }.to change(Client, :count).by(-1)
    end
  end
end
