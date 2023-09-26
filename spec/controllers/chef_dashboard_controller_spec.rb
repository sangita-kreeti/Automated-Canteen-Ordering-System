# frozen_string_literal: true

# spec/controllers/chef_dashboard_controller_spec.rb

require 'rails_helper'

RSpec.describe ChefDashboardController, type: :controller do
  describe 'GET #index' do
    context 'when a chef is authenticated' do
      let(:chef) { create(:user, role: 'chef') }

      before do
        allow(controller).to receive(:current_user).and_return(chef)
        get :index
      end

      it 'responds with a successful HTTP status' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end

      it 'assigns notifications to @notifications' do
        expect(assigns(:notifications)).to_not be_nil
      end
    end

    context 'when no chef is authenticated' do
      before { get :index }
    end
  end
end
