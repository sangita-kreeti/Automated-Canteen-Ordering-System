# frozen_string_literal: true

# This is controller
class FoodCategoriesController < ApplicationController
  before_action :set_food_category, only: %i[show edit update destroy]
  before_action :authenticate_user
  def index
    @food_categories = FoodCategory.page(params[:page]).per(10)
  end

  def show; end

  def new
    @food_category = FoodCategory.new
  end

  def create
    @food_category = FoodCategory.new(food_category_params)
    if @food_category.save
      redirect_to food_categories_path, notice: 'Food category was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @food_category.update(food_category_params)
      redirect_to food_categories_path, notice: 'Food category was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @food_category.destroy
    redirect_to food_categories_path, notice: 'Food category was successfully deleted.'
  end

  private

  def set_food_category
    @food_category = FoodCategory.find(params[:id])
  end

  def food_category_params
    params.require(:food_category).permit(:name)
  end
end
