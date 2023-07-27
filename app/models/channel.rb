# frozen_string_literal: true

# This is a model
class Channel < ApplicationRecord
  belongs_to :chef, class_name: 'User', foreign_key: 'chef_id'
  belongs_to :employee, class_name: 'User', foreign_key: 'employee_id'
  has_many :messages, dependent: :destroy
end
