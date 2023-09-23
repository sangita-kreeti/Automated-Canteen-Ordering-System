# frozen_string_literal: true

# This is controller
class FoodCategoriesController < ApplicationController
  before_action :authenticate_admin
  def index
    @food_categories = FoodCategory.page(params[:page]).per(10)
  end

  def new
    @food_category = FoodCategory.new
  end

  def create
    @food_category = FoodCategory.new(food_category_params)
    if @food_category.save
      redirect_to food_categories_path, notice: 'Food category created successfully.'
    else
      render :new
    end
  end

  def destroy
    @food_category = FoodCategory.find(params[:id])

    @food_category.destroy
    redirect_to food_categories_path, notice: 'Food category deleted successfully.'
  end

  private

  def food_category_params
    params.require(:food_category).permit(:name)
  end
end
