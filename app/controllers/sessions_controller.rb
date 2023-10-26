# frozen_string_literal: true

require 'httparty'
# This is the controller
class SessionsController < ApplicationController
  include SessionsHelper
  skip_before_action :verify_authenticity_token, only: [:destroy]
  def new; end

  def create
    user = find_or_authenticate_user
    if user
      session_and_cookies(user)
      flash[:notice] = 'You have successfully logged in.'
      redirect_user_by_role(user)
    else
      flash.now[:alert] = 'Invalid username/password.'
      render :new and return
    end
  end

  def destroy
    revoke_google_access_token
    session.delete(:user_id)
    reset_session
    flash[:notice] = 'You have logged out successfully.'
    redirect_to new_session_path
  end

  def omniauth
    user = find_or_create_user_from_omniauth
    return unless user.persisted?

    session_and_cookies(user)
    if user.role.present?
      redirect_user_by_role(user)
    else
      redirect_to complete_registration_user_path(user)
    end
  end
end
