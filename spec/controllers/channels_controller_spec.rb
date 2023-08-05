# spec/controllers/channels_controller_spec.rb
require 'rails_helper'

RSpec.describe ChannelsController, type: :controller do
  let(:user) { create(:user) } # You'll need to define a factory for User or use other user creation method
  let(:chef) { create(:user, role: 'chef', approved: true) }
  let(:employee) { create(:user, role: 'employee', approved: true) }

  describe 'GET #select_users' do
    context 'when user is an employee' do
      before { sign_in(user) } # You'll need to define the sign_in method or use a gem like Devise

      it 'renders the select_user template and assigns chefs' do
        user.update(role: 'employee')
        get :select_users
        expect(response).to render_template(:select_user)
        expect(assigns(:chefs)).to eq(User.where(role: 'chef', approved: true))
      end
    end

    context 'when user is a chef' do
      before { sign_in(user) }

      it 'renders the select_user template and assigns employees' do
        user.update(role: 'chef')
        get :select_users
        expect(response).to render_template(:select_user)
        expect(assigns(:employees)).to eq(User.where(role: 'employee', approved: true))
      end
    end
  end

  describe 'POST #create' do
    before { sign_in(user) }

    it 'creates a channel and redirects to channel path' do
      expect do
        post :create, params: { channel: { chef_id: chef.id, employee_id: employee.id } }
      end.to change(Channel, :count).by(1)
      expect(response).to redirect_to(channel_path(Channel.last))
    end

    it 'redirects to select_users_channels_path with error message on failure' do
      post :create, params: { channel: { chef_id: nil, employee_id: nil } }
      expect(response).to redirect_to(select_users_channels_path)
      expect(flash[:error]).to eq('Select one user to start the chat.')
    end
  end

  # Other controller action tests (show, send_message) can be written similarly

  # You may also want to test the private methods using controller.send(:method_name, args)
end
