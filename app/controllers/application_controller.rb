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

  def authenticate_user
    return if current_user

    redirect_to login_path,
                alert: 'You are not authorized to access this page.'
  end
end
