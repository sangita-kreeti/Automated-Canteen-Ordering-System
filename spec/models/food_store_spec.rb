# frozen_string_literal: true

# spec/models/food_store_spec.rb
require 'rails_helper'

RSpec.describe FoodStore, type: :model do
  it 'is valid with valid attributes' do
    food_category = FactoryBot.create(:food_category)
    food_store = FactoryBot.build(:food_store, food_category: food_category)
    expect(food_store).to be_valid
  end

  it 'is invalid without a food category' do
    food_store = FactoryBot.build(:food_store, food_category: nil)
    expect(food_store).not_to be_valid
  end

  it 'is invalid without name' do
    food_store = FactoryBot.build(:food_store, name: nil)
    expect(food_store).not_to be_valid
    expect(food_store.errors[:name]).to include("can't be blank")
  end

  it 'is invalid without an address' do
    food_store = FactoryBot.build(:food_store, address: nil)
    expect(food_store).not_to be_valid
    expect(food_store.errors[:address]).to include("can't be blank")
  end

  it 'is invalid without a latitude' do
    food_store = FactoryBot.build(:food_store, pincode: nil)
    expect(food_store).not_to be_valid
    expect(food_store.errors[:pincode]).to include("can't be blank")
  end
end
