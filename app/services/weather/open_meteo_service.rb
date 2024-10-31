module Weather
  class OpenMeteoService
    def initialize(location)
      @location = location
      @connection = Faraday.new(url: "https://api.open-meteo.com/v1")
    end

    def current_weather
      response = @connection.get("/forecast", {
        latitude: @location.latitude,
        longitude: @location.longitude,
        current: [ "temperature_2m", "relative_humidity_2m", "weather_code" ],
        timezone: "auto"
      })

      data = JSON.parse(response.body)
      interpret_current_weather(data)
    end

    def seven_day_forecast
      response = @connection.get("/forecast", {
        latitude: @location.latitude,
        longitude: @location.longitude,
        daily: [ "weather_code", "temperature_2m_max", "temperature_2m_min" ],
        timezone: "auto"
      })

      data = JSON.parse(response.body)
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
      # OpenMeteo Weather Code Interpretation
      case code
      when 0 then "Clear sky"
      when 1, 2, 3 then "Partly cloudy"
      when 45, 48 then "Foggy"
      when 51, 53, 55 then "Drizzle"
      when 61, 63, 65 then "Rainy"
      when 71, 73, 75 then "Snowy"
      else "Unknown conditions"
      end
    end
  end
end
