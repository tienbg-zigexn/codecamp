# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

def digest_password(string)
  cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
  BCrypt::Password.create(string, cost: cost)
end

if Book.count < 10
  10.times do
    Book.create(
      title: Faker::Book.title,
      author: Faker::Book.author,
      description: Faker::Lorem.paragraphs(number: 3).join("\n")
    )
  end
end

User.find_or_create_by!(email_address: 'test@mail.org', password_digest: digest_password('password'))

if User.count < 10
  10.times do
    User.create(
      email_address: Faker::Internet.email,
      username: Faker::Internet.username,
      display_name: Faker::Name.name,
      password: 'password',
    )
  end
end

Book.all.each do |book|
  if book.reviews.count < 5
    3.times do
      book.reviews.create(
        content: Faker::Lorem.sentences(number: 2).join(' '),
        user: User.all.sample
      )
    end
    2.times do
      book.reviews.create(
        content: Faker::Lorem.paragraphs(number: 2).join("\n"),
        user: User.all.sample
      )
    end
  end
end
