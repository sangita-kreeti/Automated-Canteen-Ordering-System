# frozen_string_literal: true

# This is a model
class FoodCategory < ApplicationRecord
  has_many :photos
  has_many :food_menus, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  
end
