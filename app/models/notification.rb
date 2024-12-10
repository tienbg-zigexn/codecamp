class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  after_create_commit :broadcast_notification

  scope :unread, -> { where(read_at: nil) }

  include Helpers::DomHelper

  def read
    update(read_at: Time.current)
  end

  private

  def broadcast_notification
    broadcast_append_later_to nested_dom_id(self.recipient, 'notifications'),
      target: 'flash', partial: 'layouts/flash_item', locals: { type: 'notice',
                                                                msg: message
      }
  end

  def message
    case self.notifiable_type
    when 'User'
      "#{self.actor.username} #{self.action} #{self.notifiable == self.recipient ? 'you.' : self.notifiable.username}"
    when 'Review'
      "#{self.actor.username} #{self.action} a review on #{self.notifiable.book.title}."
    else
      "#{self.actor.username} #{self.action} #{self.notifiable.to_s}."
    end
  end
end
