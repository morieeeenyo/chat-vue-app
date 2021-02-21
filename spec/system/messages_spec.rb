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
      expect {   
        fill_in "message_input",	with: @message.text
        sleep 1 
        click_on '送信'
        sleep 3
      }.to change(Message, :count).by(1)
      expect(page).to have_selector '.message', text: @message.text
      end
        
      
    end
    
    context "メッセージの投稿失敗" do
      it "グループが選択されていない場合テキストを入力してもアラートが出てメッセージを送信できない" do
        visit root_path
        @message = build(:message)
        expect do   
          fill_in "message_input",	with: @message.text
          sleep 1 
          click_on '送信'
          sleep 3
        end.to change(Message, :count).by(0)
        expect(page.driver.browser.switch_to.alert.text).to eq "グループが選択されていません。サイドバーより選択いただくか左上の+ボタンより新規作成してください。" #
        page.driver.browser.switch_to.alert.accept 
        expect(current_path).to  eq root_path
        expect(page).not_to have_selector '.message', text: @message.text
        expect(
          find('#message-submit')
        ).to  be_disabled #アラートを閉じると送信ボタンを送信不可にする
      end    
    end
  end
end
