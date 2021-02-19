require 'rails_helper'

RSpec.describe "Messages", type: :system do
  before do
    @chat_group = build(:chat_group)
  end

  describe "メッセージの投稿" do
    context "メッセージの投稿成功" do
     it "グループが選択されていて、テキストが存在すればメッセージの投稿ができ、即座に選択したグループに反映される" do
      select_group(@chat_group) # サイドバーからグループを選択し、非同期でグループ情報を取得
      @message = build(:message, chat_group_id: @chat_group.id)
      expect do   
       fill_in "message_input",	with: @message.text
       sleep 3
       click_on '送信'
       sleep 3
      end.to change(Message, :count).by(1)
      expect(page).to have_content '.message', text: @message.text
     end
      
    end

    context "メッセージの投稿失敗" do
      
    end
  end
end
