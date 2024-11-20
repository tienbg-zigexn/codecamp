class Review < ApplicationRecord
  belongs_to :book
  validates_presence_of :content
end
