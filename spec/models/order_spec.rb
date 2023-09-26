# frozen_string_literal: true

# spec/models/order_spec.rb

require 'rails_helper'
# rubocop:disable Metrics/BlockLength

RSpec.describe Order, type: :model do
  let(:user) { create(:user) }
  let(:food_store_name) { 'Example Food Store' }

  it 'is valid with valid attributes' do
    order = build(:order, user: user)
    expect(order).to be_valid
  end

  it 'is not valid without a user' do
    order = build(:order, user: nil)
    expect(order).not_to be_valid
  end

  it 'has many notifications' do
    association = described_class.reflect_on_association(:notifications)
    expect(association.macro).to eq(:has_many)
  end

  describe 'scopes' do
    before do
      create(:order, user: user, status: 'placed', food_store_name: food_store_name)
      create(:order, user: user, status: 'processing', food_store_name: food_store_name)
      create(:order, user: user, status: 'completed', food_store_name: 'Another Food Store')
    end

    it 'returns orders that are not placed' do
      orders = described_class.not_placed
      expect(orders.count).to eq(2)
      expect(orders.pluck(:status)).to match_array(%w[processing completed])
    end

    it 'returns orders for a specific food store' do
      orders = described_class.for_food_store(food_store_name)
      expect(orders.count).to eq(2)
      expect(orders.pluck(:status)).to match_array(%w[placed processing])
    end
  end
end
# rubocop:enable Metrics/BlockLength
