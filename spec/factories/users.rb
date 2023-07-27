# frozen_string_literal: true

# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user_#{n}" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { 'password123' }
    role { 'employee' }
    association :company, factory: :company
    association :food_store, factory: :food_store
  end
end
