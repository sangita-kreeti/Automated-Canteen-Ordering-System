# frozen_string_literal: true

# This is a table
class CreateFoodMenus < ActiveRecord::Migration[6.1]
  def change
    create_table :food_menus do |t|
      t.references :user, foreign_key: true
      t.references :food_store, foreign_key: true
      t.references :food_category, foreign_key: true
      t.string :title
      t.float :price

      t.timestamps
    end
  end
end
