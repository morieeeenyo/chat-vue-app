class Api::V1::MessagesController < ApiController
  def create 
    @chat_group = ChatGroup.find(params[:group_id])
    @message = @chat_group.message.new(text: params[:message][:text])

    if @message.save 
      ActionCable.server.broadcast 'message_channel', message: @message, group: @chat_group
    end
  end
end
