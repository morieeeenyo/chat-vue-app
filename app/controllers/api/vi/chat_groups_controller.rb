class Api::V1::ChatGroupsController < ApiController
  def create
    chat_group = ChatGroup.new(group_parans)
    if chat_group.save 
      render json: { group: chat_group }, status: :successfully_created 
    else
      render json: { errors: chat_group.errors.full_messages }, status: :failed 
    end
  end
end

