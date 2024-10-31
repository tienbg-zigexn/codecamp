class Location < ApplicationRecord
  include PgSearch::Model

  # Enable full-text search across name and country
  pg_search_scope :search_by_name_and_country,
    against: [:name, :country],
    using: {
      tsearch: { prefix: true }
    }

  # Validations
  validates :name, presence: true
  validates :latitude, presence: true, numericality: true
  validates :longitude, presence: true, numericality: true
  validates :country, presence: true

  # Associations for weather data
  has_many :weather_records, dependent: :destroy
end
