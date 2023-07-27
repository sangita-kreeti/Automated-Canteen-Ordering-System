# frozen_string_literal: true

# This is a table
class CreateChannels < ActiveRecord::Migration[6.1]
  def change
    create_table :channels do |t|
      t.integer :chef_id
      t.integer :employee_id

      t.timestamps
    end
  end
end
