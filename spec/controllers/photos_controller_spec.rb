# frozen_string_literal: true

# spec/controllers/photos_controller_spec.rb
require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe PhotosController, type: :controller do
  let(:chef) { create(:user, role: 'chef') }
  let(:food_store) { create(:food_store) }

  before do
    allow(controller).to receive(:authenticate_chef)
    allow(controller).to receive(:current_user).and_return(chef)
    chef.food_store = food_store
  end

  describe 'GET #index' do
    it 'assigns @photos' do
      get :index
    end

    it 'renders the :index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'assigns a new Photo to @photo' do
      get :new
      expect(assigns(:photo)).to be_a_new(Photo)
    end

    it 'renders the :new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    it 'redirects to photos_path with a success notice' do
    end

    context 'with invalid params' do
      it 'does not create a new Photo' do
        expect do
          post :create, params: { photo: { invalid_key: 'invalid_value' } }
        end.to_not change(Photo, :count)
      end

      it 'renders the :new template with an error' do
        post :create, params: { photo: { invalid_key: 'invalid_value' } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the specified Photo' do
      expect do
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
