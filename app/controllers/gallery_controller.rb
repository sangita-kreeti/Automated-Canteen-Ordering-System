# frozen_string_literal: true

# This is controller
class GalleryController < ApplicationController
  before_action :authenticate_user
  def index
    @photos = Photo.page(params[:page]).per(10)
  end
end
