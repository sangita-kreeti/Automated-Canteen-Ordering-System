# frozen_string_literal: true

# This is a table
class CreateOrders < ActiveRecord::Migration[6.0]
  # rubocop:disable Metrics/MethodLength
  def change
    create_table :orders do |t|
      t.text :food_item_names, array: true, default: []
      t.integer :quantities, array: true, default: []
      t.text :food_store_names, array: true, default: []
      t.integer :prices, array: true, default: []
      t.text :special_ingredients, array: true, default: []
      t.references :user, foreign_key: true
      t.string :company_name
      t.string :status

      t.timestamps
    end
  end
  # rubocop:enable Metrics/MethodLength
end
