# frozen_string_literal: true

# spec/controllers/sessions_controller_spec.rb
require 'rails_helper'

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
        expect(response).to redirect_to(admin_dashboard_path)
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
      session[:user_id] = 1
      cookies.encrypted[:user_id] = 1
      delete :destroy
      expect(session[:user_id]).to be_nil
      expect(cookies.encrypted[:user_id]).to be_nil
    end

    it 'redirects to login_path' do
      delete :destroy
      expect(response).to redirect_to(login_path)
    end
  end

  describe 'GET #omniauth' do
    let(:auth_hash) do
      {
        provider: 'google',
        uid: '12345',
        info: {
          name: 'John Doe',
          email: 'john@example.com'
        },
        credentials: {
          token: 'abcdef123456'
        }
      }
    end

    before do
      request.env['omniauth.auth'] = auth_hash
    end

    context 'with a persisted user' do
      let!(:user) { create(:user, uid: '12345', provider: 'google') }

      it 'sets user_id in session and cookies' do
        get :omniauth
        expect(session[:user_id]).to eq(user.id)
        expect(cookies.encrypted[:user_id]).to eq(user.id)
      end

      it 'redirects to the appropriate dashboard' do
        user.update(role: 'chef')
        get :omniauth
        expect(response).to redirect_to(chef_dashboard_path)
      end
    end

    context 'with a new user' do
      it 'sets user_id in session and cookies' do
        get :omniauth
        user = User.find_by(uid: '12345', provider: 'google')
        expect(session[:user_id]).to eq(user.id)
        expect(cookies.encrypted[:user_id]).to eq(user.id)
      end

      it 'redirects to edit_user_path' do
        get :omniauth
        expect(response).to redirect_to(edit_user_path(User.last))
      end
    end
  end
end
