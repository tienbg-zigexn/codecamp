class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :reviews

  has_many :active_follows, class_name: 'Follow', foreign_key: :follower_id, dependent: :destroy
  has_many :following, through: :active_follows, source: :followed

  has_many :passive_follows, class_name: 'Follow', foreign_key: :followed_id, dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower

  has_many :sent_notifications, class_name: 'Notification', foreign_key: :actor_id, dependent: :destroy
  has_many :received_notifications, class_name: 'Notification', foreign_key: :recipient_id, dependent: :destroy

  EMAIL_REGEX = /\A[a-zA-Z0-9.!\#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+\z/.freeze
  validates :email_address, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def follow(other_user)
    active_follows.create(followed: other_user)
  end

  def unfollow(other_user)
    active_follows.find_by(followed: other_user)&.destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def followed_by?(other_user)
    followers.include?(other_user)
  end
end
