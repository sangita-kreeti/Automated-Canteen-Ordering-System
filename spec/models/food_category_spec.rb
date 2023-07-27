# frozen_string_literal: true

# spec/models/food_category_spec.rb
require 'rails_helper'

RSpec.describe FoodCategory, type: :model do
  it 'is valid with a name' do
    food_category = FactoryBot.build(:food_category, name: 'Italian Cuisine')
    expect(food_category).to be_valid
  end

  it 'is invalid without a name' do
    food_category = FactoryBot.build(:food_category, name: nil)
    expect(food_category).not_to be_valid
    expect(food_category.errors[:name]).to include("can't be blank")
  end

  it 'has many photos' do
    association = FoodCategory.reflect_on_association(:photos)
    expect(association.macro).to eq(:has_many)
  end
end
