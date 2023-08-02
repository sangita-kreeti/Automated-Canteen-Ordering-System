# frozen_string_literal: true

# This is a model
class FoodStore < ApplicationRecord
  
  belongs_to :food_category, optional: true
  has_many :users, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :food_menus, dependent: :destroy

  validates :name, :address, :latitude, :longitude, presence: true
  validates :food_category_id, presence: true
  validates :name, uniqueness: true
end

