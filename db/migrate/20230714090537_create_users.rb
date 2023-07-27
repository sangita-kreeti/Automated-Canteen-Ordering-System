# frozen_string_literal: true

# This is a table
class CreateUsers < ActiveRecord::Migration[6.1]
  # rubocop:disable Metrics/MethodLength
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.integer :role
      t.string :username
      t.string :uid
      t.string :provider
      t.string :name
      t.string :phone_no
      t.integer :company_id
      t.integer :food_store_id
      t.boolean :approved, default: false

      t.timestamps
    end
    # rubocop:enable Metrics/MethodLength
  end
end
