# frozen_string_literal: true

# This is controller
class UsersController < ApplicationController
  before_action :set_user, :authenticate_user, only: %i[edit update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to edit_user_path(@user)
    else
      render :new
    end
  end

  def edit
    @companies = Company.all
    @food_stores = FoodStore.all
  end

  def update
    if @user.update(user_params)
      redirect_user_by_role
    else
      render :edit
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :role, :company_id, :food_store_id, :name, :phone_no)
  end

  def redirect_user_by_role
    case @user.role
    when 'admin'
      redirect_to admin_dashboard_index_path
    when 'employee'
      redirect_to employee_dashboard_index_path
    when 'chef'
      redirect_to chef_dashboard_index_path
    else
      # Redirect to a default path if role is not recognized
      redirect_to root_path
    end
  end
end
