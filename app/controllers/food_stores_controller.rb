# frozen_string_literal: true

# This is controller
class FoodStoresController < ApplicationController
  before_action :authenticate_user
  def index
    @food_stores = FoodStore.page(params[:page]).per(10)
  end

  def show
    @food_store = FoodStore.find(params[:id])
  end

  def new
    @food_store = FoodStore.new
  end

  def create
    @food_store = FoodStore.new(food_store_params)

    if @food_store.save
      redirect_to food_stores_path, notice: 'Food store created successfully .'
    else
      render :new
    end
  end

  def edit
    @food_store = FoodStore.find(params[:id])
  end

  def update
    @food_store = FoodStore.find(params[:id])

    if @food_store.update(food_store_params)
      redirect_to food_stores_path, notice: 'Food store updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @food_store = FoodStore.find(params[:id])
    @food_store.destroy
    redirect_to food_stores_path, notice: 'Food store destroyed successfully.'
  end

  private

  def food_store_params
    params.require(:food_store).permit(:name, :address, :latitude, :longitude)
  end
end
