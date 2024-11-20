# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if Book.count < 10
  10.times do
    Book.create(
      title: Faker::Book.title,
      author: Faker::Book.author,
      description: Faker::Lorem.paragraphs(number: 2).join('\n')
    )
  end
end

Book.all.each do |book|
  if book.reviews.count < 5
    5.times do
      book.reviews.create(
        content: Faker::Lorem.sentences(number: 2).join
      )
    end
  end
end
