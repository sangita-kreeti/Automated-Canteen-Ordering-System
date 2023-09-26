# frozen_string_literal: true

# spec/controllers/employee_dashboard_controller_spec.rb

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe EmployeeDashboardController, type: :controller do
  describe 'GET #index' do
    context 'when an employee is authenticated' do
      let(:employee) { create(:user, role: 'employee') }

      before do
        allow(controller).to receive(:current_user).and_return(employee)
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

    context 'when no employee is authenticated' do
      before { get :index }
    end
  end

  describe 'GET #profile' do
    context 'when an employee is authenticated' do
      let(:employee) { create(:user, role: 'employee') }

      before do
        allow(controller).to receive(:current_user).and_return(employee)
      end

      it 'responds with a successful HTTP status' do
        expect(response).to have_http_status(:success)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
