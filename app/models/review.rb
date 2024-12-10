class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user
  validates_presence_of :content

  scope :ordered, -> { order(created_at: :desc) }

  after_create_commit :broadcast_review_after_create
  after_destroy_commit :broadcast_review_after_destroy

  include Helpers::DomHelper

  private

  def broadcast_review_after_create
    broadcast_prepend_later_to self.book, partial: 'reviews/review_frame', target: nested_dom_id(self.book, 'reviews')
    broadcast_append_later_to self.user, partial: 'users/review', target: nested_dom_id(self.user, 'reviews')
  end

  def broadcast_review_after_destroy
    broadcast_remove_to self.book, target: nested_dom_id(self.book, self)
    broadcast_remove_to self.user, target: nested_dom_id(self.user, self)
  end
end
