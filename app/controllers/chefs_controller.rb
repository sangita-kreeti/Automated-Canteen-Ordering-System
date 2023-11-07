# frozen_string_literal: true

# This is controller
class ChefsController < ApplicationController
  before_action :authenticate_admin, except: [:dashboard]
  before_action :authenticate_chef, only: [:dashboard]

  def index
    @chefs = User.chefs.page(params[:page]).per(15)
  end

  def approve
    chef = find_chef_by_id
    if chef.update(approved: true)
      redirect_to chefs_path, notice: 'Chef approved successfully.'
    else
      redirect_to chefs_path, alert: 'Failed to approve chef.'
    end
  end

  def reject
    chef = find_chef_by_id
    chef.destroy
    redirect_to chefs_path, alert: 'Chef rejected and removed.'
  end

  def dashboard
    @notifications = current_user.notifications.order(created_at: :desc)
  end

  private

  def find_chef_by_id
    User.find(params[:id])
  end
end
