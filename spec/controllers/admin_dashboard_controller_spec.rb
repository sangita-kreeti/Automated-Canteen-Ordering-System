# frozen_string_literal: true

# spec/controllers/admin_dashboard_controller_spec.rb

require 'rails_helper'

RSpec.describe AdminDashboardController, type: :controller do
  describe 'GET #index' do
    context 'when an admin is authenticated' do
      let(:admin) { double('Admin') }

      before do
        allow(controller).to receive(:authenticate_admin).and_return(admin)
        allow(admin).to receive(:admin?).and_return(true)
        get :index
      end

      it 'responds with a successful HTTP status' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end
    end
  end
end
