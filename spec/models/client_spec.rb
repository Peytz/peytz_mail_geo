require 'rails_helper'

RSpec.describe Client, type: :model do

  describe '#create' do
    it 'creates client' do
      expect {
        Client.create(attributes_for(:client))
      }.to change(Client, :count).by(1)
    end

    context 'with already existing name' do
      let(:client) { Client.new(attributes_for(:client, name: 'test')) }

      before do
        create(:client, name: 'test')
      end

      it 'returns an error' do
        client.valid?

        expect(client.errors).to include(:name)
      end
    end
  end

  describe '#set_default_role' do
    let(:client) { create(:client, role: nil)}

    it 'creates client with role \'client\'' do

      expect(client.role).to eq('client')
    end
  end
end
