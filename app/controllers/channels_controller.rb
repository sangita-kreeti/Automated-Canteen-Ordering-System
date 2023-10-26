# frozen_string_literal: true

# This is channels_controller.rb
class ChannelsController < ApplicationController
  include ChannelsHelper
  before_action :authenticate_employee_or_chef

  def select_users
    if current_user.employee?
      @chefs = User.approved_chefs
    elsif current_user.chef?
      @employees = User.approved_employees
    end
    @channel = Channel.new
    render 'select_user', locals: { channel: @channel }
  end

  def create
    chef_id = params[:channel][:chef_id]
    employee_id = params[:channel][:employee_id]
    channel = Channel.find_or_create_by(chef_id: chef_id, employee_id: employee_id)
    if channel.persisted?
      redirect_to channel_path(channel)
    else
      flash[:error] = 'Select one user to start the chat.'
      redirect_to select_users_channels_path
    end
  end

  def show
    @channel = Channel.find(params[:id])
    @messages = @channel.messages.order(created_at: :desc)
    @message = Message.new
    session[:current_channel_id] = @channel.id
  rescue ActiveRecord::RecordNotFound
    redirect_to channel_path(session[:current_channel_id])
  end

  def send_message
    @channel = Channel.find_by(id: params[:id])
    return handle_channel_not_found unless @channel

    @message = build_message
    return handle_message_error unless @message.save

    broadcast_message
  end

  private

  def authenticate_employee_or_chef
    return if current_user && (current_user.employee? || current_user.chef?)

    handle_unauthorized_access
  end

  def message_params
    params.require(:message).permit(:content, :channel_id)
  end
end
