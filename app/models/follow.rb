class Follow < ApplicationRecord
  belongs_to :followed, class_name: "User"
  belongs_to :follower, class_name: "User"

  include Helpers::DomHelper

  after_create_commit ->(follow) {
    broadcast_append_to follow.followed, partial: "users/follow", target: nested_dom_id(follow.followed, "followers"), locals: { current_user: follow.followed, other_user: follow.follower, relationship: :passive }
    broadcast_append_to follow.follower, partial: "users/follow", target: nested_dom_id(follow.follower, "following"), locals: { current_user: follow.follower, other_user: follow.followed, relationship: :active }
  }

  after_destroy_commit ->(follow) {
    broadcast_remove_to follow.followed, target: nested_dom_id(follow.followed, follow.follower, :passive)
    broadcast_remove_to follow.follower, target: nested_dom_id(follow.follower, follow.followed, :active)
  }
end
