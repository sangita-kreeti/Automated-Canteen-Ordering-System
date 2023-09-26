# frozen_string_literal: true

# spec/factories/orders.rb
FactoryBot.define do
  factory :order do
    sequence(:status) { |n| "status_#{n}" }
    food_store_name { 'Your Food Store Name' }
    association :user, factory: :user
  end
end
