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
      redirect_to photos_path, notice: 'Photo was successfully uploaded.'
    else
      puts @photo.errors.full_messages
      render :new
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    redirect_to photos_path, notice: 'Photo was successfully deleted.'
  end

  private

  def photo_params
    params.require(:photo).permit(:image, :food_store_id, :user_id)
  end
end
