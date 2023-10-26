# frozen_string_literal: true

# This is a table
class CreateChannels < ActiveRecord::Migration[6.1]
  def change
    create_table :channels do |t|
      t.references :chef, foreign_key: { to_table: :users }
      t.references :employee, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
