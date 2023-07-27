# frozen_string_literal: true

# This is a table
class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.text :content

      t.integer :sender_id
      t.integer :recipient_id
      t.integer :channel_id
      t.timestamps
    end
  end
end
