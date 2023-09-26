# frozen_string_literal: true

# orders_helper.rb
module OrdersHelper
  RADIUS = 6371
  def calculate_distances(lat1, lon1, lat2, lon2)
    lat1_rad = to_radians(lat1)
    lon1_rad = to_radians(lon1)
    lat2_rad = to_radians(lat2)
    lon2_rad = to_radians(lon2)

    dlat = lat2_rad - lat1_rad
    dlon = lon2_rad - lon1_rad

    a = calculate_a(dlat, lat1_rad, lat2_rad, dlon)
    c = calculate_c(a)

    RADIUS * c
  end

  def update_order_status(new_status)
    order = Order.find(params[:id])

    if order.update(status: new_status)
      sender = current_user
      receiver = order.user
      message = "Order items #{order.food_item_names.join(', ')} has been #{new_status}."

      send_notifications(order, sender, receiver, message)
      redirect_to order_status_path, notice: 'Order status updated successfully.'
    else
      redirect_to order_status_path, alert: 'Failed to update order status.'
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
    @food_menus = @food_menus.filter_by_food_store(food_store_id)
  end

  def apply_food_category_filter
    return unless params[:food_category_filter].present?

    food_category_id = params[:food_category_filter].to_i
    @food_menus = @food_menus.filter_by_food_category(food_category_id)
  end

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

  def to_radians(degrees)
    degrees.to_f * Math::PI / 180
  end

  def calculate_a(dlat, lat1_rad, lat2_rad, dlon)
    Math.sin(dlat / 2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon / 2)**2
  end

  def calculate_c(arc_length_squared)
    2 * Math.atan2(Math.sqrt(arc_length_squared), Math.sqrt(1 - arc_length_squared))
  end

  def valid_user_for_distances?
    current_user.role == 'employee' && current_user.company_id.present?
  end

  def find_order_by_session
    Order.find_by(id: session[:order_id]) if session[:order_id]
  end

  def user_company_coordinates
    return [0, 0] if current_user.company_id.zero?

    company = Company.find_by(id: current_user.company_id)
    company&.values_at(:latitude, :longitude) || [0, 0]
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
