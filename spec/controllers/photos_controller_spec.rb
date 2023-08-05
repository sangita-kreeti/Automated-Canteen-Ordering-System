# frozen_string_literal: true

# spec/controllers/photos_controller_spec.rb
require 'rails_helper'

RSpec.describe PhotosController, type: :controller do
  let(:user) { create(:user) }
  let(:food_store) { create(:food_store, user: user) }
  let(:valid_attributes) { { image: fixture_file_upload('test_image.jpg', 'image/jpeg') } }
  let(:invalid_attributes) { { image: nil } }

  before { sign_in(user) }

  describe 'GET #index' do
    it 'assigns @photos' do
      photo = create(:photo, user: user, food_store: food_store)
      get :index
      expect(assigns(:photos)).to eq([photo])
    end

    it 'renders the :index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'assigns a new Photo as @photo' do
      get :new
      expect(assigns(:photo)).to be_a_new(Photo)
    end

    it 'renders the :new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Photo' do
        expect do
          post :create, params: { photo: valid_attributes }
        end.to change(Photo, :count).by(1)
      end

      it 'redirects to the photos index' do
        post :create, params: { photo: valid_attributes }
        expect(response).to redirect_to(photos_path)
      end
    end

    context 'with invalid params' do
      it 'does not create a new Photo' do
        expect do
          post :create, params: { photo: invalid_attributes }
        end.to_not change(Photo, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { photo: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:photo) { create(:photo, user: user, food_store: food_store) }

    it 'destroys the requested photo' do
      expect do
        delete :destroy, params: { id: photo.to_param }
      end.to change(Photo, :count).by(-1)
    end

    it 'redirects to the photos index' do
      delete :destroy, params: { id: photo.to_param }
      expect(response).to redirect_to(photos_path)
    end
  end
end
