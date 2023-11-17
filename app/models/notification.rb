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

  scope :unread, -> { where(read: false) }

  def self.create_employee_approved_notification(admin, employee, message)
    notification = Notification.new(sender: admin, receiver: employee, notification_type: 0,
                                    message: message)

    return unless notification.save

    ActionCable.server.broadcast("notification_channel_#{employee.id}", { message: message })
  end

  def self.create_order_notification(sender, receiver, message)
    notification = Notification.new(sender: sender, receiver: receiver, notification_type: 1,
                                    message: message)

    return unless notification.save

    ActionCable.server.broadcast("notification_channel_#{receiver.id}", { message: message })
  end

  private

  def order_status_update?
    notification_type == 'order_status_update'
  end
end
