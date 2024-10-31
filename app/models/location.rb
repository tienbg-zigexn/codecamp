class Location < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :latitude, presence: true, numericality: true
  validates :longitude, presence: true, numericality: true
  validates :country, presence: true

  # Associations for weather data
  has_many :weather_records, dependent: :destroy

  def self.search(query)
    where("name LIKE ? OR country LIKE ?", "%#{query}%", "%#{query}%")
  end
end
