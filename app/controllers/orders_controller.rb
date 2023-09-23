# frozen_string_literal: true

# This is a controller
class OrdersController < ApplicationController
  include OrdersHelper

  before_action :authenticate_chef, only: %i[received_orders]
  before_action :authenticate_employee, only: %i[index place_order order_history search]
  before_action :authenticate_admin_or_chef, only: %i[order_status]

  def index
    @food_menus = fetch_food_menus
    @order = find_order_by_session || Order.new
    @food_stores = FoodStore.all
    @food_categories = FoodCategory.all
    calculate_distances_for_employee(@food_stores) if employee_needs_distances?
  end

  def place_order
    items = params[:items]
    return render(json: { error: 'Cart is empty.' }, status: :unprocessable_entity) if items.empty?

    orders_by_food_store_result = orders_by_food_store(items)

    orders_by_food_store_result.each do |food_store_name, order_items|
      order = build_order(food_store_name)
      update_order_with_items(order, order_items)
      order.update(status: 'placed')
    end

    send_order_confirmation_emails(Order.where(status: 'placed').last(orders_by_food_store_result.size))
    render json: { success: true }
  end

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

  def approved
    update_order_status('approved')
  end

  def preparing
    update_order_status('preparing')
  end

  def finished
    update_order_status('finished')
  end

  def delivered
    update_order_status('delivered')
  end

  private

  def orders_by_food_store(items)
    items.group_by { |item| item['food_store_name'] }
  end

  def authenticate_admin_or_chef
    return if current_user && (current_user.admin? || current_user.chef?)

    handle_unauthorized_access
  end

  def fetch_food_menus
    search_results = params[:search].present? ? FoodMenu.search(params[:search]).records : FoodMenu.all
    search_results.includes(:food_store).page(params[:page]).per(10)
  end

  def group_items_by_food_store(items)
    orders_by_food_store = Hash.new { |hash, key| hash[key] = [] }

    items.each do |item|
      food_store_name = item['food_store_name']
      order_items = orders_by_food_store[food_store_name]
      unless order_items.any? { |order_item| order_item['food_item_name'] == item['food_item_name'] }
        order_items << item
      end
    end

    orders_by_food_store
  end

  def build_order(food_store_name)
    Order.new(
      food_store_name: food_store_name,
      company_name: current_user.company&.name || 'Other',
      user: current_user
    )
  end

  def update_order_with_items(order, items)
    order.food_item_names.concat(items.map { |item| item['food_item_name'] })
    order.quantities.concat(items.map { |item| item['quantity'] })
    order.prices.concat(items.map { |item| (item['quantity'] * item['price']).round(2) })
  end

  def send_order_confirmation_emails(orders)
    OrderMailer.order_confirmation_email(orders, orders.map(&:prices).flatten.sum).deliver_later
  end

  def employee_needs_distances?
    current_user.role == 'employee'
  end
end
