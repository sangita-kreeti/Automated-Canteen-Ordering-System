# frozen_string_literal: true

# This is a table
class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.bigint 'sender_id', null: false
      t.bigint 'receiver_id', null: false
      t.bigint 'order_id'
      t.text 'message'
      t.boolean 'read', default: false
      t.integer 'notification_type'

      t.index ['order_id'], name: 'index_notifications_on_order_id'

      t.timestamps
    end
  end
end
