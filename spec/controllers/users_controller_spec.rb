# frozen_string_literal: true

# spec/controllers/users_controller_spec.rb
require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) do
    {
      username: 'testuser',
      email: 'test@example.com',
      password: 'password',
      role: 'employee'
    }
  end

  let(:invalid_attributes) do
    {
      username: '',
      email: 'invalid_email',
      password: 'short',
      role: 'admin'
    }
  end

  describe 'GET #new' do
    it 'assigns a new User to @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new User' do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(complete_registration_user_path(User.last))
      end
    end

    context 'with invalid params' do
      it 'renders the :new template' do
        post :create, params: { user: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #save_registration' do
    let(:user) { create(:user) }

    context 'with valid params' do
      let(:new_attributes) do
        {
          username: 'new_username',
          role: 'chef'
        }
      end

      it 'updates the user and redirects to the appropriate dashboard' do
        session[:user_id] = user.id
        patch :save_registration, params: { user_id: user.id, user: new_attributes }
        user.reload
      end

      it 'sets a flash notice' do
        session[:user_id] = user.id
        patch :save_registration, params: { user_id: user.id, user: new_attributes }
      end
    end

    context 'with invalid params' do
      it 'does not update the user and renders the :complete_registration template' do
        session[:user_id] = user.id
        patch :save_registration, params: { user_id: user.id, user: invalid_attributes }
        user.reload
        expect(response).to render_template(:complete_registration)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
