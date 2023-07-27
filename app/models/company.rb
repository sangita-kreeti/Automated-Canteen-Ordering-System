# frozen_string_literal: true

# This is a model
class Company < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  has_many :users
end
