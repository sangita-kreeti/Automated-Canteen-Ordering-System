# frozen_string_literal: true

# spec/models/food_store_spec.rb
require 'rails_helper'

RSpec.describe FoodStore, type: :model do
  it 'is valid with valid attributes' do
    food_store = FactoryBot.build(:food_store)
    expect(food_store).to be_valid
  end

  it 'is invalid without a name' do
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
    food_store = FactoryBot.build(:food_store, latitude: nil)
    expect(food_store).not_to be_valid
    expect(food_store.errors[:latitude]).to include("can't be blank")
  end

  it 'is invalid without a longitude' do
    food_store = FactoryBot.build(:food_store, longitude: nil)
    expect(food_store).not_to be_valid
    expect(food_store.errors[:longitude]).to include("can't be blank")
  end
end
