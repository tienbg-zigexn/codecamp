class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user
  validates_presence_of :content

  scope :ordered, -> { order(created_at: :desc) }

  include ActionView::RecordIdentifier
  include ApplicationHelper

  after_create_commit ->(review) { broadcast_prepend_later_to review.book, target: nested_dom_id(review.book, 'reviews') }
  after_destroy_commit ->(review) { broadcast_remove_to review.book, target: nested_dom_id(review.book, review) }
end
