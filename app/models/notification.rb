# frozen_string_literal: true

# This is a model
class Notification < ApplicationRecord
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
  belongs_to :order, optional: true

  enum notification_type: {
    employee_approved: 0,
    order_status_update: 1
  }

  enum order_status: {
    approved: 0,
    preparing: 1,
    finished: 2,
    delivered: 3
  }

  scope :unread, -> { where(read: false) }

  def self.create_employee_approved_notification(admin, employee, message)
    notification = Notification.new(sender: admin, receiver: employee, notification_type: 'employee_approved', message: message)

    return unless notification.save

    ActionCable.server.broadcast("notification_channel_#{employee.id}", { message: message })
  end

  

  private

  def order_status_update?
    notification_type == 'order_status_update'
  end
end
