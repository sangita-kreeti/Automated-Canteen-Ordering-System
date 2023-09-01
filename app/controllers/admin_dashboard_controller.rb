# frozen_string_literal: true

# This is my controller
class AdminDashboardController < ApplicationController
  before_action :authenticate_admin

  def index; end
end
