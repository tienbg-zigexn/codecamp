# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
locations = [
  { name: 'New York', country: 'United States', latitude: 40.7128, longitude: -74.0060 },
  { name: 'London', country: 'United Kingdom', latitude: 51.5074, longitude: -0.1278 },
  { name: 'Tokyo', country: 'Japan', latitude: 35.6762, longitude: 139.6503 },
  { name: 'Hanoi', country: 'Vietnam', latitude: 21.0278, longitude: 105.8342 },
  { name: 'Da Nang', country: 'Vietnam', latitude: 16.0678, longitude: 108.2203 },
  { name: 'Ho Chi Minh', country: 'Vietnam', latitude: 10.8231, longitude: 106.6297 },
  { name: 'Thai Binh', country: 'Vietnam', latitude: 20.45, longitude: 106.333 },
  { name: 'Hai Phong', country: 'Vietnam', latitude: 20.8667, longitude: 106.6667 },
  # Add more cities
]

locations.each do |location_data|
  Location.find_or_create_by!(location_data)
end
