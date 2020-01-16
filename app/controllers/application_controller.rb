class ApplicationController < ActionController::API
  include Pundit

  rescue_from IPAddr::InvalidAddressError, with: :invalid_address_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error
  rescue_from Pundit::NotAuthorizedError, with: :unauthorized_error

  before_action :authenticate
  before_action :authorize_resource, only: [:create, :country]
  after_action :verify_authorized

  def current_user
    @current_user
  end

  def current_client
    current_user.client
  end

  def serialized_data(data)
    ActiveModelSerializers::SerializableResource.new(data)
  end

  protected

  def authenticate
    auth = Rack::Auth::Basic::Request.new(request.env)

    @current_user = Client.authenticate!(*auth.credentials)
  rescue ActiveRecord::RecordNotFound
    unauthorized_error
  end

  def model_class
    controller_name.classify.constantize
  end

  def authorize_resource
    authorize(model_class)
  end

  def validation_error(errors)
    render(
      json: {
        error: 'Validation failed',
        details: errors.full_messages
      },
      status: :unprocessable_entity
    )
  end

  def not_found_error
    render json: { error: 'Record not found' }, status: :not_found
  end

  def unauthorized_error
    render json: { error: 'Unauthorized access' }, status: :unauthorized
  end

  def invalid_address_error
    render json: { error: 'Invalid IP address' }, status: :bad_request
  end
end
