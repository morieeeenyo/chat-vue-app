require 'rails_helper'

RSpec.describe "ChatGroups", type: :system do
  include SelectGroupSupport 

  before do
    @chat_group = build(:chat_group)
  end

  describe "グループの一覧表示" do
    context "グループ一覧表示(同期)" do
      it "グループが登録されていないときサイドバーにはグループ情報が表示されていない" do
        visit root_path 
        expect(
          all('.group-list-item p').length
        ).to eq 0 
      end

      it "ルートパスにアクセスすると既に保存してあるグループがサイドバーの表示されている" do
        another_group_1 = create(:chat_group, group_name: 'another_test_1')
        another_group_2 = create(:chat_group, group_name: 'another_test_2')
        visit root_path
        # サイドバーにグループが新しい順に表示されることを検証
        expect(
          all('.group-list-item p')[-1].text 
        ).to  eq another_group_2.group_name 
        expect(
          all('.group-list-item p')[-2].text 
        ).to  eq another_group_1.group_name 
      end
      
    end
  end

  describe "グループの新規作成" do
    context "グループ新規作成成功" do
      it "グループ名を入力して作成ボタンを押すと非同期でグループが作成され、作成したチャットグループのページに遷移する。
      また、サイドバーの一番下に作成したグループのページを見るためのリンクが設置される。" do 
      # 新規作成したグループが複数あるデータの一番下に来ることを検証するためにデータを挿入
        another_group_1 = create(:chat_group, group_name: 'another_test_1')
        another_group_2 = create(:chat_group, group_name: 'another_test_2')
        visit root_path
        expect(page).to  have_link '+'
        click_link '+'
        expect(page).to  have_content '新規グループ作成'
        fill_in "group_name_input",	with: @chat_group.group_name
        expect {
          click_button '作成'
          sleep 1 #sleepがないとmysqlの処理が追いつかない
        }.to change(ChatGroup, :count).by(1)
        expect(page).to  have_selector '#group-name', text: @chat_group.group_name 
        #同じ名前のグループが作成されたときにこの検証だとやや弱い気がしている。本当はidで検証すべきかも
        expect(
          all('.group-list-item p')[-1].text 
        ).to  eq @chat_group.group_name # サイドバーの一番下にあるpタグのテキストが作成したグループ名と一致することを検証
      end
    end
    
    context "グループ新規作成失敗" do
      it "グループ名が空のままフォームを送信するとエラーメッセージが表示され、モーダルウィンドウが開いたままである" do 
        visit root_path
        expect(page).to  have_selector '#group-name', text: ""
        expect(page).to  have_link '+'
        click_link '+'
        expect(page).to  have_content '新規グループ作成'
        fill_in "group_name_input",	with: ""
        expect { 
          click_button '作成'
        }.to change(ChatGroup, :count).by(0)
        expect(page).to  have_content '新規グループ作成' #モーダルウィンドウにとどまっていることを検証
        expect(page).to  have_selector '.error-messages', text: "Group name can't be blank" #エラーメッセージの表示を確認
      end
    end
  end
  
  describe "グループ情報の取得" do
    context "グループの情報の取得(同期)" do
      it "URLを直接入力して/#/chat_groups/:idにアクセスすると現在アクセスしているグループの情報が取得できる" do
        visit root_path
        @chat_group.save
        visit "/#/chat_groups/#{@chat_group.id}" #vue-routerで設定したパスなのでprefixが存在しない
        expect(page).to have_selector '#group-name', text: @chat_group.group_name  
      end
    end
    
    context "グループ情報取得失敗" do
      it "グループのidが存在しないときURLを直接してグループのページに行こうとするとグループ情報が取得できず、アラートが出る" do
        visit root_path
        expect {
          visit "/#/chat_groups/#{@chat_group.id}" 
          sleep 2
          expect(page.driver.browser.switch_to.alert.text).to eq "不正なidです" #非同期で通信するため内部エラーが見えない。よってモーダルでアラートを表示
          sleep 1
          page.driver.browser.switch_to.alert.accept #OKを押す。ここらへんの処理は速すぎて追いつかなかったのでsleepを入れた
          sleep 1
          page.raise_server_error! #手動でサーバーエラーを発生させることで実行環境と同様のエラーを得る
        }.to raise_error(ActiveRecord::RecordNotFound)
        expect(current_path).to  eq root_path
        expect(find('#group-name').text).to eq "" #ルートパスに遷移し、ヘッダーのグループ名が空であるか検証
      end
    end
  end
  
  describe "グループの編集" do
    context "グループ情報の更新(非同期)" do
      it "group_nameを入力して送信するとヘッダーのグループ名とサイドバーのグループ名が非同期で変化し、そのグループのページに遷移する" do
        @chat_group.save
        select_group(@chat_group) # サイドバーからグループを選択し、非同期でグループ情報を取得
        expect(page).to  have_link '編集'
        click_link '編集'
        expect(page).to  have_content 'チャットグループ名変更'
        expect(page).to have_field 'group_name_input', with: @chat_group.group_name
        fill_in "group_name_input",	with: 'hoge'
        expect { 
          click_button '変更'
          sleep 1 #sleepがないとmysqlの処理が追いつかない
        }.to change(ChatGroup, :count).by(0)
        expect(page).to  have_selector '#group-name', text: 'hoge' 
        link = find('.group-list-item a')
        expect(
          link.text 
        ).to  eq 'hoge' # サイドバーの一番下にあるpタグのテキストが変更されていることを検証
      end
    end
    
    context "編集失敗" do
      it "グループが選択されていないとき編集用のモーダルウィンドウを開こうとするとアラートが出てモーダルが開かない" do
        visit root_path
        expect(find('#group-name').text).to eq "" #グループが選択されていないことを検証
        click_link '編集'
        expect(page.driver.browser.switch_to.alert.text).to eq "グループが選択されていません。サイドバーより選択いただくか左上の+ボタンより新規作成してください。" #
        page.driver.browser.switch_to.alert.accept #サーバーエラーは検証しなくてもOKで、アラートが出ることだけ検証した
        expect(current_path).to  eq root_path
      end
    end
  
      context "グループ更新失敗" do
        it "グループ名が空のままフォームを送信するとエラーメッセージが表示され、モーダルウィンドウが開いたままである" do 
          @chat_group.save
          select_group(@chat_group) # サイドバーからグループを選択し、非同期でグループ情報を取得
          expect(page).to have_content '編集'
          click_link '編集'
          expect(page).to  have_content 'チャットグループ名変更'
          expect(page).to have_field 'group_name_input', with: @chat_group.group_name
          fill_in "group_name_input",	with: ""
          expect { 
            click_button '変更'
          }.to change(ChatGroup, :count).by(0)
          expect(page).to  have_content 'チャットグループ名変更' #モーダルウィンドウにとどまっていることを検証
          expect(page).to  have_selector '.error-messages', text: "Group name can't be blank" #エラーメッセージの表示を確認
        end
      end
  end 
    
  describe "グループの削除" do
    context "グループの削除(非同期)" do
      it "サイドバーからグループを選択し、削除のモーダルウィンドウから削除ボタンを押すとグループが削除されヘッダーとサイドバーのグループ名が消える。" do 
        @chat_group.save
        select_group(@chat_group) # サイドバーからグループを選択し、非同期でグループ情報を取得
        expect(page).to have_content 'チャットグループを削除する'
        click_link 'チャットグループを削除する'
        expect(page).to have_no_field 'group_name_input', with: @chat_group.group_name #削除のときは入力欄がない
        expect { 
          click_button '削除'
          sleep 1 #sleepがないとmysqlの処理が追いつかない
        }.to change(ChatGroup, :count).by(-1)
        expect(page).to  have_selector '#group-name', text: '' #ヘッダーのテキストが消える
        expect(page).to  have_no_link @chat_group.group_name, href: "#/chat_groups/#{@chat_group.id}"
      end
    end  
    
    context "削除失敗" do
      it "グループが選択されていないとき削除用のモーダルウィンドウを開こうとするとアラートが出てモーダルが開かない" do
        visit root_path
        expect(find('#group-name').text).to eq "" #グループが選択されていないことを検証
        click_link 'チャットグループを削除する'
        expect(page.driver.browser.switch_to.alert.text).to eq "グループが選択されていません。サイドバーより選択いただくか左上の+ボタンより新規作成してください。" #
        page.driver.browser.switch_to.alert.accept #サーバーエラーは検証しなくてもOKで、アラートが出ることだけ検証した
        expect(current_path).to  eq root_path
      end
    end
  end
    
  describe "モーダルウィンドウの開閉" do
    context "新規グループ作成" do
      # 編集のときも考慮してcontext作成
      before do
        visit root_path
        expect(page).to  have_link '+'
        click_link '+'
      end
      
      it "モーダルウィンドウ内部をクリックしてもモーダルウィンドウが開いたままである" do 
        find("#content").click
        expect(page).to  have_content '新規グループ作成'
      end
      
      it "closeボタンをクリックするとモーダルウィンドウを閉じる" do
        click_button 'close', id: 'close_button'
        expect(page).to have_no_content '新規グループ作成'
      end
      
      it "モーダルウィンドウ外部をクリックするとモーダルウィンドウが閉じる" do
        find("#overlay").click
        expect(page).to  have_content '新規グループ作成'
      end
    end  

    context "グループの更新" do
      # 編集のときも考慮してcontext作成
      before do
        @chat_group.save
        select_group(@chat_group) # サイドバーからグループを選択し、非同期でグループ情報を取得
        expect(page).to have_content '編集'
        click_link '編集'
      end
      
      it "モーダルウィンドウ内部をクリックしてもモーダルウィンドウが開いたままである" do 
        find("#content").click
        expect(page).to  have_content 'チャットグループ名変更'
      end
      
      it "closeボタンをクリックするとモーダルウィンドウを閉じる" do
        click_button 'close', id: 'close_button'
        expect(page).to have_no_content 'チャットグループ名変更'
      end
      
      it "モーダルウィンドウ外部をクリックするとモーダルウィンドウが閉じる" do
        find("#overlay").click
        expect(page).to  have_content 'チャットグループ名変更'
      end
    end

    context "グループの削除" do
      # 編集のときも考慮してcontext作成
      before do
        @chat_group.save
        select_group(@chat_group) # サイドバーからグループを選択し、非同期でグループ情報を取得
        expect(page).to have_content 'チャットグループを削除する'
        click_link 'チャットグループを削除する'
        expect(page).to have_no_field 'group_name_input', with: @chat_group.group_name #削除のときは入力欄がない
      end
      
      it "モーダルウィンドウ内部をクリックしてもモーダルウィンドウが開いたままである" do 
        find("#content").click
        expect(page).to  have_content 'チャットグループ削除'
      end
      
      it "closeボタンをクリックするとモーダルウィンドウを閉じる" do
        click_button 'close', id: 'close_button'
        expect(page).to have_no_content 'チャットグループ削除'
      end
      
      it "モーダルウィンドウ外部をクリックするとモーダルウィンドウが閉じる" do
        find("#overlay").click
        expect(page).to  have_content 'チャットグループ削除'
      end
    end  
  end
end
