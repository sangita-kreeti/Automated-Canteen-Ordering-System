# frozen_string_literal: true

# This is controller
class FoodMenusController < ApplicationController
  before_action :authenticate_user, except: :destroy

  def index
    @food_menus = current_user.food_store.food_menus.page(params[:page]).per(10)
  end

  def new
    @food_menu = FoodMenu.new
  end

  def create
    @food_menu = FoodMenu.new(food_menu_params)
    @food_menu.user_id = current_user.id
    @food_menu.food_store_id = current_user.food_store.id
    @food_menu.food_category_id = current_user.food_store.food_category_id

    if @food_menu.save
      redirect_to food_menus_path, notice: 'Food menu uploaded successfully.'
    else
      flash.now[:alert] = 'Failed to upload food menu.'
      render :new
    end
  end

  def destroy
    @food_menu = FoodMenu.find(params[:id])
    @food_menu.destroy
    redirect_to food_menus_path, alert: 'Food menu deleted successfully.'
  end

  private

  def food_menu_params
    params.require(:food_menu).permit(:title, :price)
  end
end
