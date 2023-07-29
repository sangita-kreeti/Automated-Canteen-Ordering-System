# frozen_string_literal: true

# This is a model
class User < ApplicationRecord
  enum role: { employee: 0, chef: 1, admin: 2 }

  has_secure_password
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: 'should be in the format email@example.com' }
  validates :password, presence: true, on: :create
  validates_length_of :password, minimum: 4, allow_blank: true

  belongs_to :company, optional: true
  belongs_to :food_store, optional: true
  has_many :food_menus
  has_many :photos
  has_many :channels
  has_many :orders
  has_many :notifications, class_name: 'Notification', foreign_key: 'sender_id'
  has_many :notifications, class_name: 'Notification', foreign_key: 'receiver_id'
end
