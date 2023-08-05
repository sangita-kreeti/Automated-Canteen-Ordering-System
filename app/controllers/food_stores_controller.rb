# frozen_string_literal: true

# This is controller
class FoodStoresController < ApplicationController
  before_action :authenticate_user
  def index
    @food_stores = FoodStore.page(params[:page]).per(10)
  end

  def new
    @food_store = FoodStore.new
    @food_categories = FoodCategory.all
  end

  def create
    @food_categories = FoodCategory.all
    @food_store = FoodStore.new(food_store_params)
    if @food_store.save
      redirect_to food_stores_path, notice: 'Food store created successfully .'
    else
      render :new
    end
  end

  def destroy
    @food_store = FoodStore.find(params[:id])
    @food_store.destroy
    redirect_to food_stores_path, alert: 'Food store destroyed successfully.'
  end

  private

  def food_store_params
    params.require(:food_store).permit(:name, :address, :food_category_id, :latitude, :longitude)
  end
end
