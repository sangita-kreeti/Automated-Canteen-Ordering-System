# frozen_string_literal: true

# spec/models/food_menu_spec.rb
require 'rails_helper'

RSpec.describe FoodMenu, type: :model do
  let(:food_store) { FactoryBot.create(:food_store) }
  let(:user) { FactoryBot.create(:user) }

  it 'is valid with valid attributes' do
    food_menu = FactoryBot.build(:food_menu, user: user, food_store: food_store)
    expect(food_menu).to be_valid
  end

  it 'is invalid without a user' do
    food_menu = FactoryBot.build(:food_menu, user: nil, food_store: food_store)
    expect(food_menu).not_to be_valid
  end

  it 'is invalid without a food store' do
    food_menu = FactoryBot.build(:food_menu, user: user, food_store: nil)
    expect(food_menu).not_to be_valid
  end

  it 'is invalid without a title' do
    food_menu = FactoryBot.build(:food_menu, title: nil, user: user, food_store: food_store)
    expect(food_menu).not_to be_valid
    expect(food_menu.errors[:title]).to include("can't be blank")
  end

  it 'is invalid with a price greater than 1000' do
    food_menu = FactoryBot.build(:food_menu, price: 1200, user: user, food_store: food_store)
    expect(food_menu).not_to be_valid
    expect(food_menu.errors[:price]).to include('should be less than 1000')
  end
end
