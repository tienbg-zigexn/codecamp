class WeatherRefreshChannel < ApplicationCable::Channel
  def subscribed
    stream_from "weather_refresh_channel_#{params[:location]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
