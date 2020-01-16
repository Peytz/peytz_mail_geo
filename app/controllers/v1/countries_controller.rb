class V1::CountriesController < ApplicationController
  def show
    @country = Country.new(params[:ip])
    authorize @country

    geo_data = @country.geo_data

    if geo_data.nil?
      raise ActiveRecord::RecordNotFound
    else
      render json: { data: geo_data }
    end
  end
end
