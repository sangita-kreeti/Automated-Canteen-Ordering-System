# frozen_string_literal: true

# This is controller
class NotificationsController < ApplicationController
  after_create_commit do
    count = Notification.where(read: false).count
    ActionCable.server.broadcast('notification_channel', count: count, message: 'New notification created')
  end
end
