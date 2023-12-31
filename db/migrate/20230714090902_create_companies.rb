# frozen_string_literal: true

# This is a table
class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :address
      t.integer :pincode, null: false

      t.timestamps
    end
  end
end
