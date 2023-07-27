# frozen_string_literal: true

# This is notification
class NotificationChannel < ApplicationCable::Channel
  def subscribed
    current_user_id = params[:current_user_id]
    stream_from "notification_channel_#{current_user_id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
