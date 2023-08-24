# frozen_string_literal: true

class AdminDashboardController < ApplicationController
  before_action :require_admin

  def index; end

  def require_admin
    return if logged_in? && current_user.admin?

    redirect_to login_path, alert: 'You are not authorized to access this page.'
  end
end
