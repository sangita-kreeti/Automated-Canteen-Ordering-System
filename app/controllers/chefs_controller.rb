# frozen_string_literal: true

# This is controller
class ChefsController < ApplicationController
  before_action :authenticate_user
  def index
    @chefs = User.where(role: 'chef').page(params[:page]).per(15)
  end

  def approve
    chef = find_chef_by_id
    chef.update(approved: true)
    redirect_to chefs_path, notice: 'Chef approved successfully.'
  end

  def reject
    chef = find_chef_by_id
    chef.destroy
    redirect_to chefs_path, notice: 'Chef rejected and removed.'
  end

  private

  def find_chef_by_id
    User.find(params[:id])
  end
end