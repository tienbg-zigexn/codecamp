class NotificationCreator < ApplicationService
  def initialize(recipient, actor, action, notifiable)
    @recipient = recipient
    @actor = actor
    @action = action
    @notifiable = notifiable
  end

  def perform
    Notification.create!(
      recipient: @recipient,
      actor: @actor,
      action: @action,
      notifiable: @notifiable
    )
  end
end
