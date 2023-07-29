# frozen_string_literal: true

require 'httparty'
# This is the controller
class SessionsController < ApplicationController
  def new; end

  def create
    user = find_or_authenticate_user

    if user
      session_and_cookies(user)
      redirect_user_by_role(user)
    else
      flash.now[:alert] = 'Invalid username/password.'
      render :new
    end
  end

  def destroy
    revoke_google_access_token

    session.delete(:user_id)
    reset_session
    redirect_to root_path
  end

  def omniauth
    user = find_or_create_user_from_omniauth

    if user.persisted? # Check if the user is already persisted in the database (existing user)
      session_and_cookies(user)
      redirect_user_by_role(user)
    else # New user (signup)
      if user.valid?
        session_and_cookies(user)
        redirect_to edit_user_path(user)
      else
        flash[:alert] = 'Unable to login with the given credentials.'
        redirect_to login_path
      end
    end
  end


  private

  def find_or_authenticate_user
    return User.from_facebook_omniauth(request.env['omniauth.auth']) if params[:provider] == 'facebook'
    return User.from_google_omniauth(request.env['omniauth.auth']) if params[:provider] == 'google'

    find_and_authenticate_by_username_and_password
  end

  def find_and_authenticate_by_username_and_password
    user = User.find_by(username: params[:username])&.authenticate(params[:password])
    user ||= User.find_by(email: params[:username])&.authenticate(params[:password])
  
    unless user
      flash[:alert] = 'Invalid username/password.'
      redirect_to login_path
    end
  
    user
  end
  

  def session_and_cookies(user)
    cookies.encrypted[:user_id] = user.id
    session[:user_id] = user.id
    session[:access_token] = request.env['omniauth.auth']&.credentials&.token
  end

  def redirect_user_by_role(user)
    redirect_path =
      case user.role
      when 'admin' then admin_dashboard_index_path
      when 'employee' then employee_dashboard_index_path
      when 'chef' then chef_dashboard_index_path
      else
        flash[:alert] = 'Unable to login with the given credentials.'
        login_path
      end
  
    redirect_to redirect_path
  end
  

  def revoke_google_access_token
    response = HTTParty.get("https://accounts.google.com/o/oauth2/revoke?token=#{session[:access_token]}")
    session.delete(:access_token) if response.code == 200
  end

  def find_or_create_user_from_omniauth
    User.find_or_create_by(uid: omniauth_uid, provider: omniauth_provider) do |u|
      assign_user_info(u)
    end
  end

  def omniauth_uid
    request.env['omniauth.auth'][:uid]
  end

  def omniauth_provider
    request.env['omniauth.auth'][:provider]
  end

  def assign_user_info(user)
    user.username = omniauth_username
    user.email = omniauth_email
    user.password = SecureRandom.hex(15)
  end

  def omniauth_username
    request.env['omniauth.auth'][:info][:name]
  end

  def omniauth_email
    request.env['omniauth.auth'][:info][:email]
  end
end
