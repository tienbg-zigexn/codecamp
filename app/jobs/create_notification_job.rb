class CreateNotificationJob < ApplicationJob
  queue_as :notifications

  def perform(recipient, actor, action, notifiable)
    Notification.create!(
      recipient: recipient,
      actor: actor,
      action: action,
      notifiable: notifiable
    )
  end
end
