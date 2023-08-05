# frozen_string_literal: true

# spec/factories/food_categories.rb
FactoryBot.define do
  factory :food_category do
    sequence(:name) { |n| "Food Category #{n}" } # Add this line
  end
end
