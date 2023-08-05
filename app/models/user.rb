# frozen_string_literal: true

# This is a model
class User < ApplicationRecord
  has_secure_password
  belongs_to :company, optional: true
  belongs_to :food_store, optional: true
  has_many :food_menus, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :channels
  has_many :orders
  has_many :notifications, class_name: 'Notification', foreign_key: 'sender_id'
  has_many :notifications, class_name: 'Notification', foreign_key: 'receiver_id'

  validates :username, presence: true, uniqueness: true, length: { minimum: 4 } 
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: /\A[a-zA-Z0-9][\w+\-.]*@[a-zA-Z0-9][a-zA-Z0-9\-.]*\.[a-zA-Z]+\z/,
                              message: 'should be in the format email@example.com' }
  validates :password, presence: true, length: { minimum: 4 }, allow_blank: true, on: :create
  validates :role, presence: true, on: :update
  validates :company_id, presence: true, on: :update, if: -> { food_store_id.blank? }
  validates :food_store_id, presence: true, on: :update, if: -> { company_id.blank? }
  validate :either_company_or_food_store_present, on: :update
  validates :name, presence: true, length: { minimum: 4 }, on: :update,
                   format: { with: /\A[A-Za-z ]+\z/, message: 'Name will contain alphabets only' }
  validates :phone_no, presence: true, uniqueness: true, on: :update,
                       numericality: { only_integer: true, message: 'should be a valid numeric phone number' }

  enum role: { employee: 0, chef: 1, admin: 2 }

  def either_company_or_food_store_present
    return unless company_id.blank? && food_store_id.blank?

    errors.add(:base, 'Either company or food store must be present')
  end
end
