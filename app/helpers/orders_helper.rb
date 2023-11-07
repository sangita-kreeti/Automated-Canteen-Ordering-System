# frozen_string_literal: true

# orders_helper.rb
module OrdersHelper
  def update_order_status(new_status)
    order = Order.find(params[:id])

    if order.update(status: new_status)
      sender = current_user
      receiver = order.user
      message = "Order items #{order.food_item_names.join(', ')} has been #{new_status}."

      send_notifications(order, sender, receiver, message)
      redirect_to order_status_orders_path, notice: 'Order status updated successfully.'
    else
      redirect_to order_status_orders_path, alert: 'Failed to update order status.'
    end
  end

  def send_notifications(order, sender, receiver, message)
    if order.status == 'approved'
      chefs = User.chefs_for_food_store(order.food_store_name)
      chefs.each { |chef| Notification.create_order_notification(sender, chef, message) }
    end

    Notification.create_order_notification(sender, receiver, message) unless receiver.hide_notifications
  end

  def apply_search_filters
    apply_text_search
    apply_filter('food_store_filter', :food_store_id, :filter_by_food_store)
    apply_filter('food_category_filter', :food_category_id, :filter_by_food_category)
  end

  private

  def apply_text_search
    return unless params[:search].present?

    search_results = FoodMenu.search(params[:search]).records.includes(:food_store)
    @food_menus = @food_menus.merge(search_results)
  end

  def apply_filter(param_key, _record_key, scope)
    return unless params[param_key].present?

    filter_value = params[param_key].to_i
    @food_menus = @food_menus.send(scope, filter_value)
  end

  def orders_by_food_store(items)
    items.group_by { |item| item['food_store_name'] }
  end

  def fetch_food_menus
    search_results = params[:search].present? ? FoodMenu.search(params[:search]).records : FoodMenu.all
    search_results.includes(:food_store).page(params[:page]).per(10)
  end

  def build_order(food_store_name)
    Order.new(
      food_store_name: food_store_name,
      company_name: current_user.company&.name || 'Other',
      user: current_user
    )
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

  # rubocop:disable Metrics/AbcSize
  def update_order_with_items(order, items)
    order.food_item_names.concat(items.map { |item| item['food_item_name'] })
    order.quantities.concat(items.map { |item| item['quantity'].to_i })
    order.prices.concat(
      items.map do |item|
        (item['quantity'].to_i * item['price'].to_f).round(2)
      end
    )
  end
  # rubocop:enable Metrics/AbcSize

  def paginate_orders(orders)
    per_page = 10
    page = (params[:page] || 1).to_i

    total_pages = (orders.count / per_page.to_f).ceil

    start_index = (page - 1) * per_page
    end_index = start_index + per_page - 1
    end_index = orders.count - 1 if end_index >= orders.count

    paged_orders = orders[start_index..end_index]

    [paged_orders, page, total_pages]
  end

  def find_order_by_session
    Order.find_by(id: session[:order_id]) if session[:order_id]
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/AbcSize
  def calculate_distances_for_employee(food_stores)
    @distances = food_stores.map do |food_store|
      user_pincode = current_user.company_id.zero? ? current_user.pincode : current_user.company&.pincode
      company_pincode = current_user.company_id.zero? ? current_user.pincode : current_user.company&.pincode

      user_coordinates = Geocoder.coordinates(user_pincode)
      company_coordinates = Geocoder.coordinates(company_pincode)
      food_store_coordinates = Geocoder.coordinates(food_store.pincode)

      if user_coordinates.present? && food_store_coordinates.present?
        user_distance = Geocoder::Calculations.distance_between(user_coordinates, food_store_coordinates)
        company_distance = Geocoder::Calculations.distance_between(company_coordinates, food_store_coordinates)
        [food_store, user_distance.round(2), company_distance.round(2)]
      else
        [food_store, nil, nil]
      end
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/AbcSize
end
