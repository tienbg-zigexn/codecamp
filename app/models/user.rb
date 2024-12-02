class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  EMAIL_REGEX = /\A[a-zA-Z0-9.!\#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+\z/.freeze
  validates :email_address, presence: true, format: { with: EMAIL_REGEX }

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
