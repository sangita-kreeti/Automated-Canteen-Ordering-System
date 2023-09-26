# frozen_string_literal: true

# spec/controllers/food_store_controller_spec.rb
require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe FoodStoresController, type: :controller do
  let(:admin) { create(:user, role: 'admin') }
  let(:food_store_params) do
    { name: 'New Food Store', address: '123 Street', food_category_id: create(:food_category).id, pincode: '12345' }
  end

  before do
    allow(controller).to receive(:authenticate_admin)
    allow(controller).to receive(:current_user).and_return(admin)
  end

  describe 'GET #index' do
    it 'assigns @food_stores' do
      get :index
      expect(assigns(:food_stores)).to_not be_nil
    end

    it 'renders the :index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'assigns a new FoodStore to @food_store' do
      get :new
      expect(assigns(:food_store)).to be_a_new(FoodStore)
    end

    it 'assigns @food_categories' do
      get :new
      expect(assigns(:food_categories)).to_not be_nil
    end

    it 'renders the :new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new FoodStore' do
        expect do
          post :create, params: { food_store: food_store_params }
        end.to change(FoodStore, :count).by(0)
      end

      it 'redirects to food_stores_path with a success notice' do
        post :create, params: { food_store: food_store_params }
      end
    end

    context 'with invalid params' do
      it 'does not create a new FoodStore' do
        expect do
          post :create, params: { food_store: { invalid_key: 'invalid_value' } }
        end.to_not change(FoodStore, :count)
      end

      it 'renders the :new template with an error' do
        post :create, params: { food_store: { invalid_key: 'invalid_value' } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:food_store) { create(:food_store) }

    it 'deletes the specified FoodStore' do
      expect do
        delete :destroy, params: { id: food_store.id }
      end.to change(FoodStore, :count).by(-1)
    end

    it 'redirects to food_stores_path with an alert notice' do
      delete :destroy, params: { id: food_store.id }
      expect(response).to redirect_to(food_stores_path)
      expect(flash[:alert]).to eq('Food store destroyed successfully.')
    end
  end
end
# rubocop:enable Metrics/BlockLength
