class Api::V1::ChatGroupsController < ApiController
  before_action :select_group, only: [:show, :update, :destroy]
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
    render json: {group: @chat_group, messages: @chat_group.messages} #1行にrender json:としてまとめて書くならインスタンス化しないほうがいいのでは？
  end

  def update
    if @chat_group.update(group_params)
      render json: { group: @chat_group }
    else
      render json: { errors: @chat_group.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @chat_group.destroy 
      render json: { group: @chat_group }
    else
      render json: { errors: @chat_group.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private 

  def group_params
    params.fetch(:chat_group, {}).permit(:group_name) #空の値を送ったときにエラーが発生しないようにする
  end

  def select_group 
    @chat_group = ChatGroup.find(params[:id])  
  end
end

