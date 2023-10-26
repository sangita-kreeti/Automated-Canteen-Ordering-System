# frozen_string_literal: true

# This is a table
class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.text :content

      t.references :sender, foreign_key: { to_table: :users }
      t.references :recipient, foreign_key: { to_table: :users }
      t.references :channel, foreign_key: true
      t.timestamps
    end
  end
end
