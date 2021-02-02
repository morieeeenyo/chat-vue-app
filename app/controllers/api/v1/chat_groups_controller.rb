class Api::V1::ChatGroupsController < ApiController
  def index 
    render json: { groups: ChatGroup.all }
  end
  
  def create
    chat_group = ChatGroup.new(group_params)
    if chat_group.save 
      render json: { group: chat_group }, status: :created 
    else
      render json: { errors: chat_group.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show 
    render json: ChatGroup.find(params[:id])
  end

  def update
    @chat_group = ChatGroup.find(params[:id])  
    if @chat_group.update(group_params)
      render json: { group: @chat_group }
    else
      render json: { errors: @chat_group.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private 

  def group_params
    # params.require(:chat_group).permit(:group_name)
    params.fetch(:chat_group, {}).permit(:group_name)
  end
end

