# frozen_string_literal: true

# This is a model
class FoodStore < ApplicationRecord
  belongs_to :food_category, optional: true
  has_many :users, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :food_menus, dependent: :destroy

  validates :name, :address, presence: true
  validates :pincode, presence: true, format: { with: /\A\d{6}\z/, message: 'should be a 6-digit number' }
  validates :food_category_id, presence: true
  validates :name, uniqueness: true
end
