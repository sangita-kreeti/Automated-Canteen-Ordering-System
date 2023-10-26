# frozen_string_literal: true

# This is controller
class EmployeeDashboardController < ApplicationController
  before_action :authenticate_employee

  def index
    @notifications = current_user.notifications.order(created_at: :desc)
  end
end
