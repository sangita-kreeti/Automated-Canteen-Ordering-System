# frozen_string_literal: true

# This is a model
class FoodCategory < ApplicationRecord
  has_many :photos

  validates :name, presence: true
end
