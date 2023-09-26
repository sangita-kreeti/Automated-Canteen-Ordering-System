# frozen_string_literal: true

# spec/controllers/orders_controller_spec.rb
require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe OrdersController, type: :controller do
  let(:user) { create(:user) }
  let(:food_store) { create(:food_store) }
  let(:food_category) { create(:food_category) }
  let(:valid_session) { { user_id: user.id } }

  describe 'GET #index' do
    it 'assigns a list of food menus to @food_menus' do
      get :index, session: valid_session
    end

    it 'assigns a new order to @order' do
      get :index, session: valid_session
      expect(assigns(:order)).to be_a_new(Order)
    end

    it 'assigns a list of food stores to @food_stores' do
      get :index, session: valid_session
      expect(assigns(:food_stores)).to be_present
    end

    it 'assigns a list of food categories to @food_categories' do
      get :index, session: valid_session
      expect(assigns(:food_categories)).to be_present
    end
  end

  describe 'POST #place_order' do
    it 'creates a new order with valid items' do
      valid_items = [{ 'food_store_name' => food_store.name, 'food_item_name' => 'Item1', 'quantity' => 2,
                       'price' => 10.0 }]
      post :place_order, params: { items: valid_items }, session: valid_session
      expect(response).to have_http_status(:success)
    end

    it 'returns unprocessable_entity with empty cart' do
      post :place_order, params: { items: [] }, session: valid_session
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
# rubocop:enable Metrics/BlockLength
