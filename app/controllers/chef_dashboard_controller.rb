# frozen_string_literal: true

# This is controller
class ChefDashboardController < ApplicationController
  before_action :authenticate_chef

  def index; end
end
