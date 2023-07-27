# frozen_string_literal: true

# This is a helper
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

  private

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
end
