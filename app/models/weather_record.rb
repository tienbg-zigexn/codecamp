class WeatherRecord < ApplicationRecord
  belongs_to :location

  serialize :forecast_data, coder: JSON
end
