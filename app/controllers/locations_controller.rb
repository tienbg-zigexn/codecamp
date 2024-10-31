class LocationsController < ApplicationController
  def index
    @locations = Location.all
  end

  def show
    @location = Location.find(params[:id])
    @weather_record = @location.weather_records.order(created_at: :desc).first
  end

  def search
    @query = params[:query]
    @locations = Location.search_by_name_and_country(@query).limit(10)

    respond_to do |format|
      format.html
      format.json { render json: @locations }
    end
  end
end
