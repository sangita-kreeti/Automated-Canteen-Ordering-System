# frozen_string_literal: true

# channels_helper.rb
module ChannelsHelper
  def authenticate_employee_or_chef
    return if current_user && (current_user.employee? || current_user.chef?)

    handle_unauthorized_access
  end

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
