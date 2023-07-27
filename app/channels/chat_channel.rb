# frozen_string_literal: true

# This is ChatChannel
class ChatChannel < ApplicationCable::Channel
  def subscribed
    channel_id = params[:id]
    stream_from "chat_channel_#{channel_id}"
  end

  def send_message(data)
    message = Message.create(channel_id: data['channel_id'], sender_id: current_user.id, content: data['message'])
    return unless message.persisted?

    ActionCable.server.broadcast("chat_channel_#{data['channel_id']}", { message: message })
  end
end
