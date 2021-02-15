class MessageChannel < ApplicationCable::Channel
  
  def subscribed
    stop_all_streams #一度全てのストリームを止める (複数のチャネルを1画面で共有しているときは必要？)
    stream_from "message_channel_#{params['chat_group_id']}"
  end

  # メッセージを保存し、ブロードキャストするためのアクション
  def post(data)
    @chat_group = ChatGroup.find(params['chat_group_id'])
    @message = @chat_group.messages.build(text: data['message'])
    if @message.save 
     ActionCable.server.broadcast "message_channel_#{params['chat_group_id']}", message: @message, group: @chat_group
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
