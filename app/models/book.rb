class Book < ApplicationRecord
  has_many :reviews, dependent: :destroy
  validates_presence_of :title, :author, :description

  scope :ordered, -> { order(id: :desc) }

  class << self
    def search(query)
      where("title LIKE '%#{query}%' OR author LIKE '%#{query}%' OR description LIKE '%#{query}%'")
    end
  end
end
