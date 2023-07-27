# frozen_string_literal: true

# This is a model
class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :order, optional: true

  enum notification_type: {
    employee_approved: 0,
    order_status_update: 1
  }

  enum order_status: {
    placed: 0,
    approved: 1,
    preparing: 2,
    finished: 3,
    delivered: 4
  }

  scope :unread, -> { where(read: false) }

  def self.create_order_placed_notification(user, order, message)
    Notification.create(user: user, order: order, notification_type: :order_placed, message: message)
  end

  def self.create_employee_approved_notification(user, message)
    notification = Notification.new(user: user, notification_type: 'employee_approved', message: message)

    return unless notification.save

    ActionCable.server.broadcast('notification_channel_channel', { message: message }) # Pass the message parameter
  end

  def self.create_order_received_notification(user, order, message)
    Notification.create(user: user, order: order, notification_type: :order_received, message: message)
  end

  def self.create_order_status_update_notification(user, order, order_status, message)
    Notification.create(user: user, order: order, notification_type: :order_status_update,
                        order_status: order_status, message: message)
  end

  private

  def order_status_update?
    notification_type == 'order_status_update'
  end
end
