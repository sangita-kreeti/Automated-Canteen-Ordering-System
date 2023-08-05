# frozen_string_literal: true

# spec/controllers/admin_dashboard_controller_spec.rb
require 'rails_helper'

RSpec.describe AdminDashboardController, type: :controller do
  describe 'GET #index' do
    context 'when user is an admin' do
      it 'renders the index template' do
        admin_user = FactoryBot.create(:user, role: 'admin')
        allow(controller).to receive(:current_user).and_return(admin_user)

        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'when user is not an admin' do
      it 'redirects to login page with an alert' do
        non_admin_user = FactoryBot.create(:user, role: 'employee')
        allow(controller).to receive(:current_user).and_return(non_admin_user)

        get :index
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end
    end
  end
end
