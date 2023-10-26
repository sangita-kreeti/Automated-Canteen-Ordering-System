# frozen_string_literal: true

# food_menus_helper.rb
module FoodMenusHelper
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
end
