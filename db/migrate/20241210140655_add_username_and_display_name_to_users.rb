class AddUsernameAndDisplayNameToUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :username, :string
    add_column :users, :display_name, :string

    count = 1
    User.find_each do |user|
      if user.username.blank?
        user.update! username: "user_#{count}", display_name: "User #{count}"
        count += 1
      end
    end

    change_column_null :users, :username, false
    add_index :users, :username, unique: true
  end

  def down
    remove_column :users, :username
    remove_column :users, :display_name
  end
end
