class WeatherRefreshChannel < ApplicationCable::Channel
  def subscribed
    location = Location.find(params[:location])
    stream_for location
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
