class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  include Helpers::DomHelper

  scope :unread, -> { where(read_at: nil) }

  def read
    update(read_at: Time.current)
  end

  after_create_commit :broadcast_notification

  private

  def broadcast_notification
    broadcast_append_later_to nested_dom_id(self.recipient, 'notifications'),
      target: 'flash', partial: 'layouts/flash_item', locals: { type: 'notice',
                                                                msg: message
      }
  end

  def message
    case self.notifiable
    when 'User'
      "#{self.actor.email_address} #{self.action} #{self.notifiable == self.recipient ? 'you.' : self.notifiable.email_address}"
    when 'Review'
      "#{self.actor.email_address} #{self.action} a review on #{self.notifiable.book.title}."
    else
      "#{self.actor.email_address} #{self.action} #{self.notifiable.to_s}."
    end
  end
end
