class V1::ClientsController < ApplicationController
  before_action :set_client, only: [:show, :destroy]

  # GET /clients/:name
  def show
    render json: { data: serialized_data(@client) }
  end

  # POST /clients
  def create
    @client = Client.new(client_params)

    if @client.save
      render json: { data: serialized_data(@client) }, status: :created
    else
      validation_error(@client.errors)
    end
  end

  # DELETE /clients/:name
  def destroy
    @client.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find_by!(name: params[:name])
      authorize @client
    end

    # Only allow a trusted parameter "white list" through.
    def client_params
      params.fetch(:data, {}).permit(
        :name
      )
    end
end
