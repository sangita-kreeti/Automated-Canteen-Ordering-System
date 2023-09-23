# frozen_string_literal: true

# This is a model
class Order < ApplicationRecord
  belongs_to :user
  has_many :notifications

  scope :not_placed, -> { where.not(status: 'placed') }
  scope :for_food_store, -> (food_store_name) { where(food_store_name: food_store_name) }
end
