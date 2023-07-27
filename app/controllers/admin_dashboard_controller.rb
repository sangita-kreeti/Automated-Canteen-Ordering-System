# frozen_string_literal: true

# This is controller
class AdminDashboardController < ApplicationController
  before_action :require_admin
  def index; end

  def require_admin
    return if logged_in? && current_user.admin?

    redirect_to root_path,
                alert: 'You are not authorized to access this page.'
  end
end
