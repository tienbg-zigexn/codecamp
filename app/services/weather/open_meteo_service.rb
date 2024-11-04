module Weather
  class OpenMeteoService
    require 'net/http'

    BASE_URL = "https://api.open-meteo.com/v1/forecast".freeze
    def initialize(location)
      @location = location
    end

    def current_weather
      latitude = @location.latitude
      longitude = @location.longitude
      current = [ "temperature_2m", "relative_humidity_2m", "weather_code" ]
      timezone = "auto"

      url = URI("#{BASE_URL}?latitude=#{latitude}&longitude=#{longitude}&timezone=#{timezone}&current=#{current.join(",")}")
      response = Net::HTTP.get(url)

      data = JSON.parse(response)
      interpret_current_weather(data)
    end

    def seven_day_forecast
      latitude = @location.latitude
      longitude = @location.longitude
      daily = [ "weather_code", "temperature_2m_max", "temperature_2m_min" ]
      timezone = "auto"

      url = URI("#{BASE_URL}?latitude=#{latitude}&longitude=#{longitude}&timezone=#{timezone}&daily=#{daily.join(",")}")
      response = Net::HTTP.get(url)

      data = JSON.parse(response)
      interpret_forecast(data)
    end

    private

    def interpret_current_weather(data)
      {
        temperature: data.dig("current", "temperature_2m"),
        humidity: data.dig("current", "relative_humidity_2m"),
        description: weather_code_to_description(data.dig("current", "weather_code"))
      }
    end

    def interpret_forecast(data)
      data.dig("daily", "time").zip(
        data.dig("daily", "weather_code"),
        data.dig("daily", "temperature_2m_max"),
        data.dig("daily", "temperature_2m_min")
      ).map do |date, code, max_temp, min_temp|
        {
          date: Date.parse(date),
          description: weather_code_to_description(code),
          max_temperature: max_temp,
          min_temperature: min_temp
        }
      end
    end

    def weather_code_to_description(code)
      weather_code_data = YAML.load_file(Rails.root.join("data/weather_codes.yml"))
      description = weather_code_data[code.to_s]
      return "Unknown conditions" unless description

      description
    end
  end
end
