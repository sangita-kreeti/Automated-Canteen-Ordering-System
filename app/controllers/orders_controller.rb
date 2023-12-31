# frozen_string_literal: true

# This is a controller
class OrdersController < ApplicationController
  include OrdersHelper
  before_action :authenticate_chef, only: %i[received_orders]
  before_action :authenticate_employee, only: %i[index place_order order_history search]
  before_action :authenticate_admin_or_chef, only: %i[order_status]

  def menus_list
    @food_menus = fetch_food_menus
    @order = find_order_by_session || Order.new
    @food_stores = FoodStore.all
    @food_categories = FoodCategory.all
    calculate_distances_for_employee(@food_stores)
  end

  # rubocop:disable Metrics/MethodLength
  def place_order
    items = params[:items]
    return render(json: { error: 'Cart is empty.' }, status: :unprocessable_entity) if items.nil? || items.empty?

    orders = items.map do |item|
      food_store_name = item['food_store_name']
      order = build_order(food_store_name, [item])
      order.update(status: 'placed')
      order
    end
    orders.each do |order|
      OrderMailer.order_confirmation_email(order).deliver_later
    end
    render json: { success: true }
  end
  # rubocop:enable Metrics/MethodLength

  def search
    @food_menus = FoodMenu.includes(:food_store)
    apply_search_filters
    @food_stores = FoodStore.all
    @food_categories = FoodCategory.all
    @distances = calculate_distances_for_employee(@food_stores)
    render partial: 'search_results'
  end

  def order_history
    @orders = current_user.orders.order(created_at: :desc).page(params[:page]).per(10)
    render 'order_history'
  end

  def received_orders
    approved_orders = Order.where.not(status: 'placed')
    @orders = approved_orders.where(food_store_name: current_user.food_store.name).page(params[:page]).per(10)
  end

  def order_status
    orders = Order.all.sort_by do |order|
      [order.company_name == 'Other' ? 1 : 0, order.company_name]
    end
    
    @orders, page, total_pages = paginate_orders(orders)
    render 'order_status', locals: { orders: @orders, page: page, total_pages: total_pages }
  end

  def change_status
    update_order_status(params[:status_key])
  end

  private

  def authenticate_admin_or_chef
    return if current_user && (current_user.admin? || current_user.chef?)

    handle_unauthorized_access
  end
end
