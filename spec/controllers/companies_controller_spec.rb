# frozen_string_literal: true

# spec/controllers/companies_controller_spec.rb
require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe CompaniesController, type: :controller do
  let(:admin) { create(:user, role: 'admin') }
  let(:company_params) { { name: 'New Company', address: '123 Street', pincode: '12345' } }

  before do
    allow(controller).to receive(:authenticate_admin)
    allow(controller).to receive(:current_user).and_return(admin)
  end

  describe 'GET #index' do
    it 'assigns @companies' do
      get :index
    end

    it 'renders the :index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'assigns a new Company to @company' do
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
          post :create, params: { company: company_params }
        end.to change(Company, :count).by(0)
      end

      it 'redirects to companies_path with a success notice' do
        post :create, params: { company: company_params }
      end
    end

    context 'with invalid params' do
      it 'does not create a new Company' do
        expect do
          post :create, params: { company: { invalid_key: 'invalid_value' } }
        end.to_not change(Company, :count)
      end

      it 'renders the :new template with an error' do
        post :create, params: { company: { invalid_key: 'invalid_value' } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:company) { create(:company, name: 'Unique Company Name') }

    it 'deletes the specified Company' do
      expect do
        delete :destroy, params: { id: company.id }
      end.to change(Company, :count).by(-1)
    end

    it 'redirects to companies_path with a success notice' do
      delete :destroy, params: { id: company.id }
      expect(response).to redirect_to(companies_path)
      expect(flash[:notice]).to eq('Company destroyed successfully.')
    end
  end
end
# rubocop:enable Metrics/BlockLength
