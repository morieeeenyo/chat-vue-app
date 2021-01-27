class Api::V1::ChatGroupsController < ApiController
  def create
    chat_group = ChatGroup.new(group_parans)
    if chat_group.save 
      render json: { group: chat_group }, status: :created 
    else
      render json: { errors: chat_group.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show 
    render json: ChatGroup.find(params[:id])
  end

  private 

  def group_parans
    params.require(:chat_group).permit(:group_name)
  end
end

