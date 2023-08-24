# frozen_string_literal: true

# This is a table
class CreateUsers < ActiveRecord::Migration[6.1]
  # rubocop:disable Metrics/MethodLength
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.integer :role, null: false
      t.string :username, null: false
      t.string :uid
      t.string :provider
      t.string :name, null: false
      t.string :phone_no, null: false
      t.integer :company_id
      t.integer :food_store_id
      t.boolean :approved, default: false
      t.boolean :hide_notifications, default: false

      t.timestamps
    end
    # rubocop:enable Metrics/MethodLength
  end
end
