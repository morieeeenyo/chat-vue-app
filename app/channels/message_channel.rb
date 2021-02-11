class MessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "message_channel"
  end

  # メッセージをブロードキャストするためのアクション
  def speak(data)
    ActionCable.server.broadcast 'message_channel', message: data['message']
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
