# frozen_string_literal: true

# This is a model
class Order < ApplicationRecord
  belongs_to :user
  has_many :notifications  

  scope :not_placed, -> { where.not(status: 'placed') }
  scope :for_food_store, ->(food_store_name) { where(food_store_name: food_store_name) }

  # Calculate the distance between two sets of coordinates
  def self.calculate_distance(lat1, lon1, lat2, lon2)
    radius = 6371 # Radius of the Earth in kilometers

    lat1_rad = to_radians(lat1)
    lon1_rad = to_radians(lon1)
    lat2_rad = to_radians(lat2)
    lon2_rad = to_radians(lon2)

    dlat = lat2_rad - lat1_rad
    dlon = lon2_rad - lon1_rad

    a = calculate_a(dlat, lat1_rad, lat2_rad, dlon)
    c = calculate_c(a)

    radius * c
  end

  def self.to_radians(degrees)
    degrees.to_f * Math::PI / 180
  end

  def self.calculate_a(dlat, lat1_rad, lat2_rad, dlon)
    Math.sin(dlat / 2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon / 2)**2
  end

  def self.calculate_c(arc_length_squared)
    2 * Math.atan2(Math.sqrt(arc_length_squared), Math.sqrt(1 - arc_length_squared))
  end
end
