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

  validates :username, presence: true, uniqueness: { message: '%<value>s is already taken' }, length: { minimum: 4 }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: /\A[a-zA-Z0-9][\w+\-.]*@[a-zA-Z0-9][a-zA-Z0-9\-.]*\.[a-zA-Z]+\z/,
                              message: 'should be in the format email@example.com' }
  validates :password, presence: true, length: { minimum: 4 }, allow_blank: true, on: :create
  validates :role, presence: { message: 'must be present' }, on: :update
  validates :company_id, presence: { message: 'must be present' }, on: :update, if: lambda {
                                                                                      food_store_id.blank?
                                                                                    }
  validates :food_store_id, presence: { message: 'must be present' }, on: :update, if: lambda {
                                                                                         company_id.blank?
                                                                                       }
  validate :either_company_or_food_store_present, on: :update

  validate :other_company_name_presence_when_company_id_zero, on: :update
  validate :pincode_presence_when_company_id_zero, on: :update

  validates :name, presence: true, length: { minimum: 4 }, on: :update,
                   format: { with: /\A[A-Za-z ]+\z/, message: '%<value>s is not a valid name' }
  validates :phone_no, presence: true,
                       uniqueness: { message: '%<value>s is already taken' },
                       length: { is: 10, message: 'should be exactly 10 digits' },
                       on: :update,
                       numericality: { only_integer: true, message: '%<value>s is not a valid phone number' }

  scope :approved_chefs, -> { where(role: 'chef', approved: true) }
  scope :approved_employees, -> { where(role: 'employee', approved: true) }
  scope :company_employees, -> { where(role: 'employee').where.not(company_id: 0) }
  scope :ordinary_employees, -> { where(role: 'employee', company_id: 0) }
  scope :chefs, -> { where(role: 'chef') }
  scope :employees, -> { where(role: 'employee') }
  scope :chefs_for_food_store, lambda { |food_store_name|
    where(role: 'chef')
      .joins(:food_store)
      .where(food_stores: { name: food_store_name })
  }

  enum role: { employee: 0, chef: 1, admin: 2 }

  def either_company_or_food_store_present
    return unless company_id.blank? && food_store_id.blank?

    errors.add(:base, 'Either company or food store must be present')
  end

  def other_company_name_presence_when_company_id_zero
    return unless role == 'employee' && company_id.zero?

    if other_company_name.blank?
      errors.add(:other_company_name, "can't be blank")
    elsif !other_company_name.match(/\A[A-Za-z]+\z/)
      errors.add(:other_company_name, 'should only contain letters (uppercase and lowercase)')
    end
  end

  def pincode_presence_when_company_id_zero
    return unless role == 'employee' && company_id.zero?

    pincode_str = pincode.to_s

    if pincode.blank?
      errors.add(:pincode, 'must be present')
    elsif pincode_str.length != 6 || !pincode_str.match(/\A\d{6}\z/)
      errors.add(:pincode, 'should be exactly 6 digits')
    end
  end
end
