# frozen_string_literal: true

# orders_helper.rb
module OrdersHelper
  RADIUS = 6371

  # rubocop:disable Metrics/AbcSize
  def calculate_distance(lat1, lon1, lat2, lon2)
    lat1_rad = to_radians(lat1)
    lon1_rad = to_radians(lon1)
    lat2_rad = to_radians(lat2)
    lon2_rad = to_radians(lon2)

    dlat = lat2_rad - lat1_rad
    dlon = lon2_rad - lon1_rad

    a = Math.sin(dlat / 2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon / 2)**2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    RADIUS * c
  end
  # rubocop:enable Metrics/AbcSize

  def update_order_status(new_status, message)
    order = Order.find(params[:id])

    if order.update(status: new_status)
      sender = current_user
      receiver = order.user
      Notification.create_order_notification(sender, receiver, message) unless receiver.hide_notifications
      redirect_to order_status_path, notice: 'Order status updated successfully.'
    else
      redirect_to order_status_path, alert: 'Failed to update order status.'
    end
  end

  def apply_search_filters
    apply_text_search
    apply_food_store_filter
    apply_food_category_filter
  end

  private

  def apply_text_search
    return unless params[:search].present?

    search_results = FoodMenu.search(params[:search]).records.includes(:food_store)
    @food_menus = @food_menus.merge(search_results)
  end

  def apply_food_store_filter
    return unless params[:food_store_filter].present?

    food_store_id = params[:food_store_filter].to_i
    @food_menus = @food_menus.where(food_store_id: food_store_id)
  end

  def apply_food_category_filter
    return unless params[:food_category_filter].present?

    food_category_id = params[:food_category_filter].to_i
    @food_menus = @food_menus.where(food_category_id: food_category_id)
  end

  def paginate_orders(orders)
    per_page = 10
    page = (params[:page] || 1).to_i

    total_orders = orders.count
    total_pages = (total_orders / per_page.to_f).ceil

    start_index = (page - 1) * per_page
    end_index = start_index + per_page - 1
    end_index = total_orders - 1 if end_index >= total_orders

    paged_orders = orders[start_index..end_index]

    [paged_orders, page, total_pages]
  end

  def to_radians(degrees)
    degrees.to_f * Math::PI / 180
  end

  def calculate_distances(food_stores)
    return [] unless valid_user_for_distances?

    user_latitude, user_longitude = user_coordinates

    food_stores.map do |food_store|
      [food_store, calculate_distance(user_latitude, user_longitude, food_store.latitude, food_store.longitude)]
    end
  end

  def valid_user_for_distances?
    current_user.role == 'employee' && current_user.company_id.present?
  end

  def user_coordinates
    return [0, 0] if current_user.company_id.zero?

    company = Company.find_by(id: current_user.company_id)
    company&.values_at(:latitude, :longitude) || [0, 0]
  end

  def find_order_by_session
    Order.find_by(id: session[:order_id]) if session[:order_id]
  end

  def calculate_distances_for_employee(food_stores)
    return unless employee_needs_distances?

    @distances = calculate_distances(food_stores).map do |food_store, distance|
      [food_store, distance.round(2)]
    end
  end
end
