# frozen_string_literal: true

# spec/factories/food_stores.rb
FactoryBot.define do
  factory :food_store do
    sequence(:name) { |n| "Food Store #{n}" }
    address { 'Address' }
    food_category { association :food_category }
    pincode { 700_091 }
  end
end
