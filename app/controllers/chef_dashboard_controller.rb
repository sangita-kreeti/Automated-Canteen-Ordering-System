# frozen_string_literal: true

# This is controller
class ChefDashboardController < ApplicationController
  before_action :require_chef

  def index; end

  def require_chef
    return if logged_in? && current_user.chef?

    redirect_to login_path,
                alert: 'You are not authorized to access this page.'
  end
end
