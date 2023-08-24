# frozen_string_literal: true

# This is channels_controller.rb
class ChannelsController < ApplicationController
  before_action :authenticate_user
  def select_users
    if current_user.employee?
      @chefs = User.where(role: 'chef', approved: true)
    elsif current_user.chef?
      @employees = User.where(role: 'employee', approved: true)
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

  def message_params
    params.require(:message).permit(:content, :channel_id)
  end

  def build_message
    Message.new(
      message_params.merge(
        channel_id: @channel.id,
        sender_id: current_user.id,
        recipient_id: current_user.employee? ? @channel.chef_id : @channel.employee_id
      )
    )
  end

  def broadcast_message
    message_content = @message.content
    sender_name = User.find(@message.sender_id).name
    ActionCable.server.broadcast("chat_channel_#{params[:id]}",
                                 { message_content: message_content, sender_name: sender_name })

    respond_to do |format|
      format.js { head :ok }
      format.html { redirect_to @channel }
    end
  end

  def handle_message_error
    error_message = @message.errors.full_messages.join(', ')
    respond_to do |format|
      format.js { render js: "alert('Failed to send message: #{error_message}');" }
      format.html { redirect_to @channel }
    end
  end

  def handle_channel_not_found
    respond_to do |format|
      format.js { render js: "alert('Channel not found');" }
      format.html { redirect_to channels_path }
    end
  end
end
