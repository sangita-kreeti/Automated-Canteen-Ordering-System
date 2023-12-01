# frozen_string_literal: true

# This is a table
class CreateOrders < ActiveRecord::Migration[6.0]
  # rubocop:disable Metrics/MethodLength
  def change
    create_table :orders do |t|
      t.text :food_item_name
      t.integer :quantity
      t.string :food_store_name
      t.integer :price
      t.text :special_ingredient
      t.references :user, foreign_key: true
      t.string :company_name
      t.string :status

      t.timestamps
    end
  end
  # rubocop:enable Metrics/MethodLength
end
