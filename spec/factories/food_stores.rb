# frozen_string_literal: true

# spec/factories/food_stores.rb
FactoryBot.define do
  factory :food_store do
    name { 'Example Food Store' }
    address { '123 Main Street, City' }
    latitude { 40.7128 } # Example latitude value
    longitude { -74.0060 } # Example longitude value
  end
end
