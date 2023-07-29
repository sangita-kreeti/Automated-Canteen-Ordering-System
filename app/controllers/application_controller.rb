# frozen_string_literal: true

# This is controller
class ApplicationController < ActionController::Base
  # Make the `current_user` and `logged_in?` methods accessible as helper methods
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def authenticate_user
    return if current_user

    redirect_to login_path
  end
end