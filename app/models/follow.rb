class Follow < ApplicationRecord
  belongs_to :followed, class_name: "User"
  belongs_to :follower, class_name: "User"

  after_create_commit ->(follow) {
    broadcast_append_to follow.followed, partial: "users/follow", target: helpers.nested_dom_id(follow.followed, "followers"), locals: { user: follow.follower, relationship: :passive }
    broadcast_append_to follow.follower, partial: "users/follow", target: helpers.nested_dom_id(follow.follower, "following"), locals: { user: follow.followed, relationship: :active }
  }

  after_destroy_commit ->(follow) {
    broadcast_remove_to follow.followed, target: helpers.nested_dom_id(follow.followed, follow.follower, :passive)
    broadcast_remove_to follow.follower, target: helpers.nested_dom_id(follow.follower, follow.followed, :active)
  }

  private
  
  def helpers
    ApplicationController.helpers
  end
end
