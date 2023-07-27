# frozen_string_literal: true

# This is a model
class Photo < ApplicationRecord
  belongs_to :user
  belongs_to :food_store

  has_one_attached :image
end
