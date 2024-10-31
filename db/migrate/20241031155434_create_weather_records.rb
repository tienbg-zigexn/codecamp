class CreateWeatherRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :weather_records do |t|
      t.references :location, null: false, foreign_key: true
      t.float :current_temperature
      t.string :current_description
      t.json :forecast_data

      t.timestamps
    end
  end
end
