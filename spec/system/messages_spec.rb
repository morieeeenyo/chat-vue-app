require 'rails_helper'
Capybara.server = :puma #ActionCableを使うために必要ぽい

RSpec.describe "Messages", type: :system do
  before do
    @chat_group = build(:chat_group)
  end

  describe "メッセージの投稿" do
    context "メッセージの投稿成功" do
      it "グループが選択されていて、テキストが存在すればメッセージの投稿ができ、即座に選択したグループにのみ反映される" do
        @chat_group.save
        another_group = create(:chat_group, group_name: 'hoge test')
        select_group(@chat_group) # サイドバーからグループを選択し、非同期でグループ情報を取得
        @message = build(:message)
        expect {   
          fill_in "message_input",	with: @message.text
          sleep 1 
          click_on '送信'
          sleep 3
        }.to change(Message, :count).by(1)
        expect(page).to have_selector '.message', text: @message.text
        expect(all('.message').length).to eq 1 #メッセージが1件しか投稿されていないことを検証
        #選択していないグループにはメッセージが表示されていないことを検証
        click_link another_group.group_name, href: "#/chat_groups/#{another_group.id}"
        expect(page).to  have_selector '#group-name', text: another_group.group_name
        expect(page).not_to have_selector '.message', text: @message.text
      end

      it "グループを移動してもメッセージの投稿が重複しない" do
        # 実行環境でよく起きたバグなので検証したい
        @chat_group.save
        another_group = create(:chat_group, group_name: 'hoge test')
        select_group(@chat_group) # サイドバーからグループを選択し、非同期でグループ情報を取得
        click_link another_group.group_name, href: "#/chat_groups/#{another_group.id}"
        expect(page).to  have_selector '#group-name', text: another_group.group_name
        #元いたグループに戻る。ここで実行環境だとメッセージの投稿が重複することがあり、フロント側で重複を防いでいる。
        click_link @chat_group.group_name, href: "#/chat_groups/#{@chat_group.id}"
        expect(page).to  have_selector '#group-name', text: @chat_group.group_name
        @message = build(:message, chat_group_id: @chat_group.id)
        expect {   
          fill_in "message_input",	with: @message.text
          sleep 1 
          click_on '送信'
          sleep 3
        }.to change(Message, :count).by(1)
        expect(page).to have_selector '.message', text: @message.text
        expect(all('.message').length).to eq 1 #メッセージが1件しか投稿されていないことを検証
      end
    end
    
    context "メッセージの投稿失敗" do
      it "グループが選択されていない場合テキストを入力してもアラートが出てメッセージを送信できない" do
        visit root_path
        @message = build(:message)
        expect {   
          fill_in "message_input",	with: @message.text
          sleep 1 
          click_on '送信'
          sleep 3
        }.to change(Message, :count).by(0)
        expect(page.driver.browser.switch_to.alert.text).to eq "グループが選択されていません。サイドバーより選択いただくか左上の+ボタンより新規作成してください。" #
        page.driver.browser.switch_to.alert.accept 
        expect(current_path).to  eq root_path
        expect(page).not_to have_selector '.message', text: @message.text
        expect(
          find('#message-submit')
        ).to  be_disabled #アラートを閉じると送信ボタンを送信不可にする
      end 
      
      it "グループが選択されていてもテキストがスペースを含む空文字列の場合メッセージを送信できない" do
        @chat_group.save
        select_group(@chat_group)
        @message = build(:message, chat_group_id: @chat_group.id)
        expect {   
          fill_in "message_input",	with: ""
          sleep 2
          expect(
            find('#message-submit')
          ).to  be_disabled #テキストが空だと送信ボタンが動かない
          fill_in "message_input",	with: "   "
          sleep 2
          expect(
            find('#message-submit')
          ).to  be_disabled #スペースを入れても送信ボタンが動かない
        }.to change(Message, :count).by(0)
        expect(page).not_to have_selector '.message', text: @message.text
      end    
    end
  end
    
  describe "メッセージの表示" do
    context "メッセージの表示成功" do
      it "ルートパスに移動しグループを選択すると既に保存してあるメッセージが表示される。" do
        @chat_group.save 
        @messages = create_list(:message, 5, chat_group_id: @chat_group.id)
        select_group(@chat_group) # サイドバーからグループを選択し、非同期でグループ情報を取得  
        expect(all('.message').length).to eq 5  #ページを読み込んだときに既に保存してあるメッセージが表示されることはここで検証
      end
    end
  end

  describe "メッセージの削除" do
    context "メッセージの削除成功" do
      it "グループを削除するとグループに投稿されていたメッセージも同時に削除される" do
        @chat_group.save 
        @messages = create_list(:message, 5, chat_group_id: @chat_group.id)
        select_group(@chat_group) # サイドバーからグループを選択し、非同期でグループ情報を取得  
        expect(all('.message').length).to eq 5  #ページを読み込んだときに既に保存してあるメッセージが表示されることはここで検証
        expect {   
          click_link 'チャットグループを削除する'
          click_button '削除'
          sleep 1 #sleepがないとmysqlの処理が追いつかない
        }.to change(Message, :count).by(-5)
      end
    end
  end
end
