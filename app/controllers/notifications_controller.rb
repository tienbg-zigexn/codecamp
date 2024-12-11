class NotificationsController < ApplicationController
  before_action :set_notification, only: %i[show mark_as_read]
  before_action :set_notifications, only: %i[index mark_all_as_read]

  def index; end

  def show
    case @notification.notifiable_type
    when 'User'
      redirect_to @notification.actor
    when 'Review'
      redirect_to book_review_path(@notification.notifiable.book, @notification.notifiable)
    end
  end

  def mark_as_read
    respond_to do |format|
      format.html { redirect_to user_notifications_path(Current.user), notice: "Notification has been marked as read." }
      # todo: turbo_stream
    end
  end

  def mark_all_as_read
    @notifications.update_all(read_at: Time.current)
    respond_to do |format|
      format.html { redirect_to user_notifications_path(Current.user), notice: "All notifications have been marked as read." }
      # todo: turbo_stream
    end
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
    @notification.read
  end

  def set_notifications
    @notifications = Current.user.received_notifications.unread
  end
end
