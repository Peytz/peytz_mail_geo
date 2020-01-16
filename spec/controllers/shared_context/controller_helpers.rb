RSpec.shared_context 'controller helpers', :shared_context => :metadata do
  # Authorization
  let(:current_client) { create(:client) }
  
  before do
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Basic.encode_credentials(
        current_client.name,
        current_client.api_key
      )
  end

  def json_parsed(body)
    JSON.parse(body).with_indifferent_access
  end
end
