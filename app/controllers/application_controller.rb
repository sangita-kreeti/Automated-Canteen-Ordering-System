# frozen_string_literal: true

# This is controller
class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def authenticate_admin
    return if current_user&.admin?

    handle_unauthorized_access
  end

  def authenticate_employee
    return if current_user&.employee?

    handle_unauthorized_access
  end

  def authenticate_chef
    return if current_user&.chef?

    handle_unauthorized_access
  end

  def mark_all_as_read
    current_user.notifications.update_all(read: true)
    render json: { status: 'success' }
  end

  def not_found_method
    render file: "#{Rails.public_path}/404.html", status: :not_found, layout: false
  end

  private

  def handle_unauthorized_access
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end
end
