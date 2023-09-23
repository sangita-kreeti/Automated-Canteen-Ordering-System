# frozen_string_literal: true

# This is a model
class Company < ApplicationRecord
  has_many :users

  validates :name, presence: true, uniqueness: true
  validates :address, presence: true
  validates :pincode, presence: true, format: { with: /\A\d{6}\z/, message: 'should be a 6-digit number' }
end
