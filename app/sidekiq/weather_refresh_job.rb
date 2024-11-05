class WeatherRefreshJob
  include Sidekiq::Job

  def perform
    Location.find_each do |location|
      refresh_location_weather(location)
      # WeatherRefreshChannel.broadcast_to(location, location)
      ActionCable.server.broadcast "weather_refresh_channel_#{location.name}", location
    end
  end

  private

  def refresh_location_weather(location)
    service = Weather::OpenMeteoService.new(location)

    # Create or update weather record
    weather_record = location.weather_records.find_or_initialize_by(
      created_at: Date.today.beginning_of_day..Date.today.end_of_day
    )

    current_weather = service.current_weather
    forecast = service.seven_day_forecast

    weather_record.update(
      current_temperature: current_weather[:temperature],
      current_description: current_weather[:description],
      forecast_data: forecast
    )
  end
end
