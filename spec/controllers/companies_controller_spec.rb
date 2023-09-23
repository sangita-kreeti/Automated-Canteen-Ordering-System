# frozen_string_literal: true

# spec/controllers/companies_controller_spec.rb
require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  let(:valid_attributes) do
    {
      name: 'Test Company',
      address: '123 Test Street',
      pincode: 700_091
    }
  end

  describe 'GET #index' do
    it 'assigns all companies as @companies' do
      company = create(:company) # Make sure you have the FactoryBot setup for Company
      get :index
      expect(assigns(:companies)).to eq([company])
    end

    it 'renders the :index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'assigns a new Company as @company' do
      get :new
      expect(assigns(:company)).to be_a_new(Company)
    end

    it 'renders the :new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Company' do
        expect do
          post :create, params: { company: valid_attributes }
        end.to change(Company, :count).by(1)
      end

      it 'redirects to the companies list' do
        post :create, params: { company: valid_attributes }
        expect(response).to redirect_to(companies_path)
      end
    end

    context 'with invalid params' do
      it 'does not create a new Company' do
        expect do
          post :create, params: { company: invalid_attributes }
        end.to_not change(Company, :count)
      end

      it 'renders the :new template' do
        post :create, params: { company: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:company) { create(:company) } # Make sure you have the FactoryBot setup for Company

    it 'destroys the requested company' do
      expect do
        delete :destroy, params: { id: company.to_param }
      end.to change(Company, :count).by(-1)
    end

    it 'redirects to the companies list' do
      delete :destroy, params: { id: company.to_param }
      expect(response).to redirect_to(companies_path)
    end
  end
end
