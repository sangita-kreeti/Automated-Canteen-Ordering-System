# frozen_string_literal: true

# This is controller
class NotificationsController < ApplicationController
  def mark_as_read
    notification = Notification.find(params[:id])
    notification.update(read: true)
    render json: { status: 'success' }
  end

  def mark_all_as_read
    current_user.notifications.update_all(read: true)
    render json: { status: 'success' }
  end
end
