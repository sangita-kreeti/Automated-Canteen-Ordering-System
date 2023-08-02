# frozen_string_literal: true

# This is a table
class CreateFoodStores < ActiveRecord::Migration[6.1]
  def change
    create_table :food_stores do |t|
      t.string :name
      t.string :address
      t.integer :food_category_id, foreign_key: true
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
