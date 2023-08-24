# frozen_string_literal: true

# This is a table
class CreatePhotos < ActiveRecord::Migration[6.1]
  def change
    create_table :photos do |t|
      t.string :image

      t.references :user, foreign_key: true, null: false
      t.references :food_store, foreign_key: true, null: false
      t.timestamps
    end
  end
end
