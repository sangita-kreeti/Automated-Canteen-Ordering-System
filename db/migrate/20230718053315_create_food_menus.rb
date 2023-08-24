# frozen_string_literal: true

# This is a table
class CreateFoodMenus < ActiveRecord::Migration[6.1]
  def change
    create_table :food_menus do |t|
      t.references :user, foreign_key: true, null: false
      t.references :food_store, foreign_key: true, null: false
      t.references :food_category, foreign_key: true, null: false
      t.string :title, null: false
      t.float :price, null: false

      t.timestamps
    end
  end
end
