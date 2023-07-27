# frozen_string_literal: true

# This is a model
class Order < ApplicationRecord
  belongs_to :user
  has_many :notifications
end
