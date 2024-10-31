class LocationsController < ApplicationController
  def index
    @locations = Location.all
  end

  def show
    @location = Location.find(params[:id])
    @weather_record = @location.weather_records.last
  end

  def search
    @query = params[:query]
    @locations = Location.search(@query).limit(10)

    respond_to do |format|
      format.html
      format.json { render json: @locations }
    end
  end
end
