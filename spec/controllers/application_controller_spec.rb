# spec/controllers/application_controller_spec.rb
require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: 'Hello, World!'
    end
  end

  describe '#current_user' do
    it 'returns the current user' do
      user = FactoryBot.create(:user)
      session[:user_id] = user.id
      expect(controller.current_user).to eq(user)
    end

    it 'returns nil if user is not logged in' do
      session[:user_id] = nil
      expect(controller.current_user).to be_nil
    end
  end

  describe '#logged_in?' do
    it 'returns true if user is logged in' do
      user = FactoryBot.create(:user)
      session[:user_id] = user.id
      expect(controller.logged_in?).to be_truthy
    end

    it 'returns false if user is not logged in' do
      session[:user_id] = nil
      expect(controller.logged_in?).to be_falsy
    end
  end

  describe '#authenticate_user' do
    context 'when user is logged in' do
      it 'does not redirect' do
        user = FactoryBot.create(:user)
        session[:user_id] = user.id
        get :index
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the login path' do
        controller.authenticate_user
        get :index
        expect(response).to redirect_to(login_path)
      end

      it 'sets an alert flash message' do
        controller.authenticate_user
        get :index
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end
    end
  end
end
