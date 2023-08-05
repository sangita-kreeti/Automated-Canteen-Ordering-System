# frozen_string_literal: true

# This is controller
class PhotosController < ApplicationController
  before_action :authenticate_user
  def index
    @photos = current_user.food_store.photos.page(params[:page]).per(15)
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = current_user.photos.build(photo_params)
    @photo.food_store_id = current_user.food_store_id

    if @photo.save
      redirect_to photos_path, notice: 'Photo uploaded successfully.'
    else
      flash.now[:alert] = 'Please upload a photo!'
      render :new
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    redirect_to photos_path, alert: 'Photo deleted successfully.'
  end

  private

  def photo_params
    params.require(:photo).permit(:image) if params[:photo].present?
  end
end
