# frozen_string_literal: true

# This is a model
class FoodStore < ApplicationRecord
  belongs_to :food_category, optional: true
  has_many :users
  has_many :photos
  has_many :food_menus

  validates :name, presence: true, uniqueness: true 
  validates :address, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
end
