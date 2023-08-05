require 'rails_helper'

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
        expect do
          post :create, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'redirects to edit_user_path' do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(edit_user_path(User.last))
      end
    end

    context 'with invalid params' do
      it 'does not create a new User' do
        expect do
          post :create, params: { user: invalid_attributes }
        end.to_not change(User, :count)
      end

      it 'renders the :new template' do
        post :create, params: { user: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    let(:user) { create(:user) }

    it 'assigns the requested user to @user' do
      get :edit, params: { id: user.to_param }
      expect(assigns(:user)).to eq(user)
    end

    it 'assigns all companies to @companies' do
      get :edit, params: { id: user.to_param }
      expect(assigns(:companies)).to eq(Company.all)
    end

    it 'assigns all food stores to @food_stores' do
      get :edit, params: { id: user.to_param }
      expect(assigns(:food_stores)).to eq(FoodStore.all)
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user) }

    context 'with valid params' do
      let(:new_attributes) do
        {
          username: 'new_username',
          role: 'chef'
        }
      end

      it 'updates the requested user' do
        patch :update, params: { id: user.to_param, user: new_attributes }
        user.reload
        expect(user.username).to eq('new_username')
        expect(user.role).to eq('chef')
      end

      it 'redirects to appropriate dashboard based on user role' do
        new_attributes[:role] = 'employee'
        patch :update, params: { id: user.to_param, user: new_attributes }
        expect(response).to redirect_to(employee_dashboard_index_path)
      end

      it 'sets a flash notice' do
        patch :update, params: { id: user.to_param, user: new_attributes }
        expect(flash[:notice]).to eq('Successfully registration completed')
      end
    end

    context 'with invalid params' do
      it 'does not update the user' do
        patch :update, params: { id: user.to_param, user: invalid_attributes }
        user.reload
        expect(user.username).to_not eq('')
        expect(user.role).to_not eq('invalid_role')
      end

      it 'renders the :edit template' do
        patch :update, params: { id: user.to_param, user: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end
end
