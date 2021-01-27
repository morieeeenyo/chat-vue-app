require 'rails_helper'

RSpec.describe "ChatGroups", type: :system do
  before do
    @chat_group = build(:chat_group)
  end
  

  context "グループ新規作成成功" do
    it "グループ名を入力して作成ボタンを押すと非同期でグループが作成され、作成したチャットグループのページに遷移すること" do 
      visit root_path
      expect(page).to  have_selector '.group-name', text: ""
      expect(page).to  have_button '+'
      click_button '+'
      expect(page).to  have_content 'チャットグループ新規作成'
      fill_in "group_name_input",	with: @chat_group.group_name
      expect do 
        click_button '作成'
        sleep 1 #sleepがないとmysqlの処理が追いつかない
      end.to change(ChatGroup, :count).by(1)
      expect(page).to  have_selector '.group-name', text: @chat_group.group_name #同じ名前のグループが作成されたときにこの検証だとやや弱い気がしている
      #作成されたグループのidを使ってグループが保存できたことを検証すべきか？
    end
    
  end

  context "グループ新規作成失敗" do
    it "グループ名が空のままフォームを送信するとエラーメッセージが表示され、モーダルウィンドウが開いたままであること" do 
      visit root_path
      expect(page).to  have_selector '.group-name', text: ""
      expect(page).to  have_button '+'
      click_button '+'
      expect(page).to  have_content 'チャットグループ新規作成'
      fill_in "group_name_input",	with: ""
      expect do 
        click_button '作成'
      end.to change(ChatGroup, :count).by(0)
      expect(page).to  have_content 'チャットグループ新規作成' #モーダルウィンドウにとどまっていることを検証
      expect(page).to  have_selector '.error-messages', text: "Group name can't be blank" #エラーメッセージの表示を確認
    end
    
  end

  context "モーダルウィンドウの開閉" do
    before do
      visit root_path
      expect(page).to  have_button '+'
      click_button '+'
    end
    
    it "モーダルウィンドウ内部をクリックしてもモーダルウィンドウが開いたままである" do 
      find("#content").click
      expect(page).to  have_content 'チャットグループ新規作成'
    end

    it "closeボタンをクリックするとモーダルウィンドウを閉じる" do
      click_button 'close', id: 'close_button'
      expect(page).to have_no_content 'チャットグループ新規作成'
    end

    it "モーダルウィンドウ外部をクリックするとモーダルウィンドウが閉じる" do
      find("#overlay").click
      expect(page).to  have_content 'チャットグループ新規作成'
    end
    
    
  end

  context "グループの情報の取得(同期)" do
    it "URLを直接入力して/#/chat_groups/:idにアクセスすると現在アクセスしているグループの情報が取得できる" do
      visit root_path
      @chat_group.save
      visit "/#/chat_groups/#{@chat_group.id}" #vue-routerで設定したパスなのでprefixが存在しない
      expect(page).to have_selector '.group-name', text: @chat_group.group_name  
    end
    
    
  end
  
  


  

  
end
