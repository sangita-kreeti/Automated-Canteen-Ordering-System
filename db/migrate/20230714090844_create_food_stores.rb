# frozen_string_literal: true

# This is a table
class CreateFoodStores < ActiveRecord::Migration[6.1]
  def change
    create_table :food_stores do |t|
      t.string :name, null: false
      t.string :address
      t.integer :food_category_id, foreign_key: true, null: false
      t.integer :pincode, null: false

      t.timestamps
    end
  end
end
