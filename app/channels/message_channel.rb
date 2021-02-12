class MessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "message_channel"
  end

  # メッセージを保存し、ブロードキャストするためのアクション
  def post(data)
    @chat_group = ChatGroup.find(data['group']['id'])
    @message = @chat_group.messages.build(text: data['message'])
    if @message.save 
     ActionCable.server.broadcast 'message_channel', message: @message, group: @chat_group
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
