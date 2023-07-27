# frozen_string_literal: true

# This is controller
class FoodMenusController < ApplicationController
  before_action :set_food_menu, only: %i[edit update destroy]
  before_action :authenticate_user
  def index
    @food_menus = if current_user.chef?
                    current_user.food_store.food_menus.includes(:food_category).page(params[:page]).per(10)
                  else
                    FoodMenu.includes(:food_category).page(params[:page]).per(15)
                  end

    @food_categories = FoodCategory.all
  end

  def new
    @food_menu = FoodMenu.new
    @food_categories = FoodCategory.all
  end

  def create
    @food_menu = current_user.food_menus.build(food_menu_params)
    @food_menu.food_store_id = current_user.food_store_id

    if save_food_menu
      redirect_to food_menus_path, notice: 'Food menu was successfully uploaded.'
    else
      @food_categories = FoodCategory.all
      flash.now[:alert] = 'Failed to upload food menu.'
      render :new
    end
  end

  def edit
    @food_categories = FoodCategory.all
  end

  def update
    if @food_menu.update(food_menu_params)
      redirect_to food_menus_path, notice: 'Food menu was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @food_menu.destroy
    redirect_to food_menus_path, notice: 'Food menu was successfully deleted.'
  end

  private

  def set_food_menu
    @food_menu = FoodMenu.find(params[:id])
  end

  def save_food_menu
    @food_menu.save.tap do |success|
      puts @food_menu.errors.full_messages unless success
    end
  end

  def food_menu_params
    params.require(:food_menu).permit(:title, :food_category_id, :price, :food_store_id)
  end
end
