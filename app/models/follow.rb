class Follow < ApplicationRecord
  belongs_to :followed, class_name: "User"
  belongs_to :follower, class_name: "User"

  after_create_commit :broadcast_follow_after_create
  after_destroy_commit :broadcast_follow_after_destroy

  private

  include Helpers::DomHelper

  def broadcast_follow_after_create
    broadcast_append_later_to self.followed, partial: "users/follow",
                                       target: nested_dom_id(self.followed, "followers"),
                                       locals: { current_user: self.followed, other_user: self.follower, relationship: :passive }
    broadcast_append_later_to self.follower, partial: "users/follow",
                                       target: nested_dom_id(self.follower, "following"),
                                       locals: { current_user: self.follower, other_user: self.followed, relationship: :active }
  end

  def broadcast_follow_after_destroy
    broadcast_remove_to self.followed, target: nested_dom_id(self.followed, self.follower, :passive)
    broadcast_remove_to self.follower, target: nested_dom_id(self.follower, self.followed, :active)
  end
end
