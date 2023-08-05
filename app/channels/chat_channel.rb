# frozen_string_literal: true

# This is ChatChannel
class ChatChannel < ApplicationCable::Channel
  def subscribed
    channel_id = params[:id]
    stream_from "chat_channel_#{channel_id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
