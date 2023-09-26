# frozen_string_literal: true

# spec/controllers/food_categories_controller_spec.rb
require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe FoodCategoriesController, type: :controller do
  let(:admin) { create(:user, role: 'admin') }
  let(:food_category_params) { { name: 'New Category' } }

  before do
    allow(controller).to receive(:authenticate_admin)
    allow(controller).to receive(:current_user).and_return(admin)
  end

  describe 'GET #index' do
    it 'assigns @food_categories' do
      _food_categories = create_list(:food_category, 3)
      get :index
    end

    it 'renders the :index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'assigns a new FoodCategory to @food_category' do
      get :new
      expect(assigns(:food_category)).to be_a_new(FoodCategory)
    end

    it 'renders the :new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new FoodCategory' do
        expect do
          post :create, params: { food_category: food_category_params }
        end.to change(FoodCategory, :count).by(1)
      end

      it 'redirects to food_categories_path with a success notice' do
        post :create, params: { food_category: food_category_params }
        expect(response).to redirect_to(food_categories_path)
        expect(flash[:notice]).to eq('Food category created successfully.')
      end
    end

    context 'with invalid params' do
      it 'does not create a new FoodCategory' do
        expect do
          post :create, params: { food_category: { invalid_key: 'invalid_value' } }
        end.to_not change(FoodCategory, :count)
      end

      it 'renders the :new template with an error' do
        post :create, params: { food_category: { invalid_key: 'invalid_value' } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:food_category) { create(:food_category) }

    it 'deletes the specified FoodCategory' do
      expect do
        delete :destroy, params: { id: food_category.id }
      end.to change(FoodCategory, :count).by(-1)
    end

    it 'redirects to food_categories_path with a success notice' do
      delete :destroy, params: { id: food_category.id }
      expect(response).to redirect_to(food_categories_path)
      expect(flash[:notice]).to eq('Food category deleted successfully.')
    end
  end
end
# rubocop:enable Metrics/BlockLength
