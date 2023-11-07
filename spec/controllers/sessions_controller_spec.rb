# frozen_string_literal: true

# spec/controllers/sessions_controller_spec.rb
require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe SessionsController, type: :controller do
  describe 'GET #new' do
    it 'renders the :new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid credentials' do
      let(:user) { create(:user, username: 'testuser', password: 'password') }

      it 'sets user_id in session and cookies' do
        post :create, params: { username: user.username, password: 'password' }
        expect(session[:user_id]).to eq(user.id)
        expect(cookies.encrypted[:user_id]).to eq(user.id)
      end

      it 'redirects to the appropriate dashboard' do
        user.update(role: 'admin')
        post :create, params: { username: user.username, password: 'password' }
        expect(response).to redirect_to(dashboard_employees_path)
      end
    end

    context 'with invalid credentials' do
      it 'renders the :new template with alert' do
        post :create, params: { username: 'invalid', password: 'invalid' }
        expect(response).to render_template(:new)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'clears user_id from session and cookies' do
      session[:user_id] = nil
      cookies.encrypted[:id] = nil

      expect(session[:user_id]).to be_nil
      expect(cookies.encrypted[:user_id]).to be_nil
    end
  end
end
# rubocop:enable Metrics/BlockLength
