# frozen_string_literal: true

# This is controller
class FoodMenusController < ApplicationController
  before_action :authenticate_chef, except: :destroy

  def index
    @food_menus = current_user.food_store.food_menus.page(params[:page]).per(10)
  end

  def new
    @food_menu = FoodMenu.new
  end

  def create
    build_food_menu
    if save_food_menu
      redirect_to food_menus_path, notice: 'Food menu uploaded successfully.'
    else
      render_error('Failed to upload food menu.')
    end
  end

  def destroy
    @food_menu = FoodMenu.find(params[:id])
    @food_menu.destroy
    redirect_to food_menus_path, notice: 'Food menu deleted successfully.'
  end

  private

  def build_food_menu
    @food_menu = FoodMenu.new(food_menu_params)
    @food_menu.user_id = current_user.id
    @food_menu.food_store_id = current_user.food_store.id
    @food_menu.food_category_id = current_user.food_store.food_category_id
  end

  def save_food_menu
    @food_menu.save
  end

  def render_error(message)
    flash.now[:alert] = message
    render :new
  end

  def food_menu_params
    params.require(:food_menu).permit(:title, :price)
  end
end
