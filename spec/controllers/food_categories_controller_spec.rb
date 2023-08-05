require 'rails_helper'

RSpec.describe FoodCategoriesController, type: :controller do
  let(:user) { create(:user) }  # Assuming you have a FactoryBot factory named :user

  describe 'GET #index' do
    it 'assigns @food_categories and renders the index template' do
      food_category = create(:food_category)
      get :index
      expect(assigns(:food_categories)).to eq([food_category])
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    before { sign_in(user) }

    it 'assigns a new FoodCategory to @food_category and renders the new template' do
      get :new
      expect(assigns(:food_category)).to be_a_new(FoodCategory)
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid parameters' do
      it 'creates a new food category and redirects to index with a notice' do
        expect do
          post :create, params: { food_category: attributes_for(:food_category) }
        end.to change(FoodCategory, :count).by(1)
        expect(response).to redirect_to(food_categories_path)
        expect(flash[:notice]).to eq('Food category created successfully.')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new food category and renders the new template' do
        expect do
          post :create, params: { food_category: { name: nil } }
        end.not_to change(FoodCategory, :count)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in(user) }
    let!(:food_category) { create(:food_category) }

    it 'destroys the food category and redirects to index with an alert' do
      expect do
        delete :destroy, params: { id: food_category.id }
      end.to change(FoodCategory, :count).by(-1)
      expect(response).to redirect_to(food_categories_path)
      expect(flash[:alert]).to eq('Food category deleted successfully.')
    end
  end
end
