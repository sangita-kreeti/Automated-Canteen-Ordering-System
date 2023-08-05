# frozen_string_literal: true

# This is a model
class Company < ApplicationRecord
  has_many :users

  validates :name, presence: true, uniqueness: true
  validates :address, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
end
