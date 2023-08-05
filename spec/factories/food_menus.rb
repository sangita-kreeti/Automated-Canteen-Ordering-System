# frozen_string_literal: true

# spec/factories/food_stores.rb
FactoryBot.define do
  factory :food_menu do
    title { 'Delicious Dish' }
    price { 500 }
    association :user
    association :food_store
  end
end
