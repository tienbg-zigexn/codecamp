class AddDescriptionToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :description, :text
  end
end
