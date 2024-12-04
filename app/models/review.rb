class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user
  validates_presence_of :content

  scope :ordered, -> { order(created_at: :desc) }

  after_create_commit ->(review) { broadcast_prepend_later_to review.book, partial: 'reviews/review_frame', target: helpers.nested_dom_id(review.book, 'reviews') }
  after_destroy_commit ->(review) {
    broadcast_remove_to review.book, target: helpers.nested_dom_id(review.book, review)
    broadcast_remove_to review.user, target: helpers.nested_dom_id(review.user, review)
  }

  private

  def helpers
    ApplicationController.helpers
  end
end
