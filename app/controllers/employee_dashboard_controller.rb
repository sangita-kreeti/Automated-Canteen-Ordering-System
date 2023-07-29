# frozen_string_literal: true

# This is controller
class EmployeeDashboardController < ApplicationController
  before_action :require_employee

  def index
    @notifications = current_user.notifications.order(created_at: :desc)
  end

  def profile; end

  def require_employee
    return if logged_in? && current_user.employee?

    redirect_to root_path,
                alert: 'You are not authorized to access this page.'
  end
end
