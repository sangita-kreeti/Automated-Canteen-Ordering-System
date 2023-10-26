# frozen_string_literal: true

# This is controller
class UsersController < ApplicationController
  include UsersHelper
  before_action :set_user
  before_action :authenticate_employee_or_chef, only: %i[edit update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = 'Please complete your profile first!.'
      redirect_to complete_registration_user_path(@user)
    else
      render :new
    end
  end

  def complete_registration
    @user = User.find(session[:user_id])
    @companies = Company.all
    @food_stores = FoodStore.all
  end

  def save_registration
    @user = User.find(params[:user_id])

    if @user.update(user_params)
      redirect_user_by_role(@user)
      flash[:notice] = 'Successfully completed registration'
    else
      @companies = Company.all
      @food_stores = FoodStore.all
      render :complete_registration
    end
  end

  def edit
    @user = User.find(params[:id])

    if @user.id != session[:user_id]
      flash[:alert] = 'You are not authorized to access this page.'
      redirect_to edit_user_path(session[:user_id])
    end
  rescue ActiveRecord::RecordNotFound
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'Profile updated successfully.' if @user.previous_changes.any?
      redirect_user_by_role(@user)
    else
      render :edit
    end
  end

  def redirect_to_complete_registration
    user_id = params[:user_id]
    redirect_to complete_registration_user_path(user_id)
  end

  private

  def set_user
    @user = current_user
  end

  def authenticate_employee_or_chef
    return if current_user && (current_user.employee? || current_user.chef?)

    handle_unauthorized_access
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :role, :company_id, :food_store_id, :name, :phone_no,
                                 :pincode, :other_company_name)
  end
end
