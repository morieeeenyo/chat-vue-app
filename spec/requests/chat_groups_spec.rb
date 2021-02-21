require 'rails_helper'

RSpec.describe "ChatGroups", type: :request do
  before do
    @chat_group = build(:chat_group) 
  end

  describe "api/v1/chat_groups#index" do
        
    context "正しいurlにアクセスしたとき" do
      it "リクエストが成功すること" do
        get api_v1_chat_groups_path, xhr: true
        #getメソッドを使用した際の成功ステータスは200
        expect(response.status).to eq 200
      end

      it "DBに保存されたすべてのグループの情報がidが小さい順にレスポンスとして返ってくること" do
        @chat_group.save 
        chat_group_2 = create(:chat_group) #順番を検証するために2つめのデータを挿入
        get api_v1_chat_groups_path, xhr: true
        json = JSON.parse(response.body)        
        expect(json['groups'][0]['id']).to eq @chat_group.id
        expect(json['groups'][1]['id']).to eq chat_group_2.id
      end

      it "グループがDBに存在しないとき、空の配列が返却されること" do
        get api_v1_chat_groups_path, xhr: true
        json = JSON.parse(response.body)   
        # eq []としても通ったが念の為型と要素の数を分けた
        expect(json['groups']).to be_a_kind_of(Array)
        expect(json['groups'].length).to eq 0
      end
      
      
    end
    
  end
  
  describe "api/v1/chat_groups#create" do
    before do
      #paramsとして送るために.attributesを使用 
      @chat_group_params = @chat_group.attributes 
    end
    
    context "パラメータが正しいとき" do
      it "リクエストが成功すること" do
        post api_v1_chat_groups_path,  xhr: true, params: { chat_group: @chat_group_params } 
        #リソースを保存する処理の成功時のステータスは201
        expect(response).to have_http_status(201) 
      end
  
      it "chat_groupsテーブルに一つデータが追加されること" do
        expect do  #長いのでブロックで引数に渡してます
         post api_v1_chat_groups_path, xhr: true, params: { chat_group: @chat_group_params  }
         #ChatGroupモデルの数が1増えていることを検証
        end.to change(ChatGroup, :count).by(1) 
      end
  
      it "json形式で正しくデータが返却されること" do
        post api_v1_chat_groups_path, xhr: true, params: { chat_group: @chat_group_params  }
        #返却されたデータをjson形式に変換     
        json = JSON.parse(response.body) 
        #パラメータとして送った値とレスポンスの中身が合っているか検証
        expect(json['group']['group_name']).to eq @chat_group_params['group_name']
      end
    end

    context "パラメータが不正な場合" do
      before do
        # バリデーションに引っかかってエラーメッセージが
        # 返却されることを検証するためにgroup_nameを空にする。
        @chat_group_params[:group_name] = nil 
      end
      
      it "リクエストに失敗すること" do
        post api_v1_chat_groups_path, xhr: true, params: { chat_group: @chat_group_params  }
        #リクエストには成功したがパラメータが不正のとき、422でステータスコードが返ってくる
        expect(response).to have_http_status(422) 
      end

      it "chat_groupsテーブルのデータが増えていないこと" do
        #長いのでブロックで引数に渡してます
        expect do  
          post api_v1_chat_groups_path, xhr: true, params: { chat_group: @chat_group_params  }
          #ChatGroupモデルの数が増えていないことを検証
        end.to change(ChatGroup, :count).by(0) 
      end

      it "エラーメッセージがjson形式で返却されること" do
        post api_v1_chat_groups_path, xhr: true, params: { chat_group: @chat_group_params  }
        #返却されたデータをjson形式に変換
        json = JSON.parse(response.body) 
        # コントローラーのエラーハンドリングでバリデーションに
        # 引っかかった場合はエラーメッセージを返すようにしている
        expect(json['errors']).to include "Group name can't be blank" 
      end
      
    end
    
  end

  describe "api/v1/chat_groups#show" do
    before do
      #showアクション時はレコードがすでに存在しているのでインスタンスを保存
      @chat_group.save 
    end
    
    context "グループが存在するとき" do
      it "リクエストに成功すること" do       
        get api_v1_chat_group_path(@chat_group), xhr: true
        #getメソッドを使用した際の成功ステータスは200
        expect(response.status).to eq 200
      end

      it "JSON形式で正しくデータが返却されること" do     
        @message = create_list(:message, 3, chat_group_id: @chat_group.id)
        get api_v1_chat_group_path(@chat_group), xhr: true
        json = JSON.parse(response.body)        
        #送ったパラメータとレスポンスのデータが一致しているか検証
        expect(json['group']['id']).to eq @chat_group['id']
        #メッセージが紐付いているかも検証
        json['messages'].each do |message|
          expect(message['id']).not_to  eq nil
          expect(message['chat_group_id']).to  eq @chat_group.id
        end  
      end
    end

    context "グループが存在しないとき" do
      it "idがnilのとき" do    
        @chat_group.id = nil
        expect  do
          get api_v1_chat_group_path(@chat_group), xhr: true
          #idがnilのときはリクエストがそもそも送信できない
        end.to raise_error ActionController::UrlGenerationError 
      end
      
      #idが存在するが値が不正のときはリクエストを送ったあとで
      #レコードが見つからないと言われる
      it "idが0のときエラーが発生すること" do       
        @chat_group.id = 0
        expect  do
          get api_v1_chat_group_path(@chat_group), xhr: true  
        end.to raise_error ActiveRecord::RecordNotFound 
      end

      it "idがfloat型のときエラーが発生すること" do       
        @chat_group.id = 1.5
        expect  do
          get api_v1_chat_group_path(@chat_group), xhr: true  
        end.to raise_error ActiveRecord::RecordNotFound 
      end
      
    end
  end
    
    describe "api/v1/chat_group#update" do
      before do
        #編集時は既にDBにレコードが保存されている
        @chat_group.save
      end
      
      
      context "パラメータが正しいとき" do
        it "リクエストが成功すること" do
          # group_nameを変更しつつidはそのままparamsに入れる
          patch api_v1_chat_group_path(@chat_group),  xhr: true, params: { chat_group: { group_name: 'hoge'}, id: @chat_group.id } 
          expect(response).to have_http_status(200) 
        end

        it "group_nameが更新されること" do
          patch api_v1_chat_group_path(@chat_group),  xhr: true, params: { chat_group: { group_name: 'hoge'}, id: @chat_group.id } 
          # リソースの更新にはリロードが必要
          expect(@chat_group.reload.group_name).to eq 'hoge'
        end

        it "更新されたデータがjson形式で返却されること" do
          patch api_v1_chat_group_path(@chat_group),  xhr: true, params: { chat_group: { group_name: 'hoge'}, id: @chat_group.id } 
          json = JSON.parse(response.body)  
          expect(json['group']['group_name']).to eq 'hoge'
        end
        
      end

      context "不正なパラメータが送信されたとき" do
        before do
          # バリデーションに引っかかってエラーメッセージが
          # 返却されることを検証するためにgroup_nameを空にする。
          patch api_v1_chat_group_path(@chat_group),  xhr: true, params: { chat_group: { group_name: ''}, id: @chat_group.id } 
        end
        
        it "リクエストに失敗すること" do
          #リクエストには成功したがパラメータが不正のとき、422でステータスコードが返ってくる
          expect(response).to have_http_status(422) 
        end
  
        it "chat_groupsテーブルのデータが更新されていないこと" do
          # 更新しようとしたグループ情報が更新されていないことを検証
          expect(@chat_group.reload.group_name).to eq @chat_group.group_name
        end
  
        it "エラーメッセージがjson形式で返却されること" do
          #返却されたデータをjson形式に変換
          json = JSON.parse(response.body) 
          # コントローラーのエラーハンドリングでバリデーションに
          # 引っかかった場合はエラーメッセージを返すようにしている
          expect(json['errors']).to include "Group name can't be blank" 
        end
      end
    end
    describe "api/v1/chat_group#destroy" do
      before do
        #削除時は既にDBにレコードが保存されている
        @chat_group.save
      end

      context "パラメータが正しいとき" do

        it "リクエストに成功すること" do
          delete api_v1_chat_group_path(@chat_group),  xhr: true
          expect(response).to have_http_status(200)
        end

        it "パラメータとして送ったチャットグループのレコードが削除されること" do
          expect do 
           delete api_v1_chat_group_path(@chat_group),  xhr: true
          end.to change(ChatGroup, :count).by(-1)
        end

        it "削除されたグループの情報がレスポンスとして返却されること" do
          delete api_v1_chat_group_path(@chat_group),  xhr: true
          json = JSON.parse(response.body)  
          expect(json['group']['id']).to eq @chat_group.id
        end

        it "グループの削除に成功するとグループに紐づくメッセージも削除されること" do
          @messages = create_list(:message, 5, chat_group_id: @chat_group.id)
          expect{
            delete api_v1_chat_group_path(@chat_group),  xhr: true
            expect(response).to have_http_status(200)
          }.to change(Message, :count).by(-5)
        end
        
      end

      context "削除に失敗するとき" do
        it "二重にリクエストを送ると2回目で削除に失敗する" do
          delete api_v1_chat_group_path(@chat_group),  xhr: true
           expect do 
            delete api_v1_chat_group_path(@chat_group),  xhr: true
           end.to raise_error ActiveRecord::RecordNotFound 
        end
        # パラメータが不正な場合もdestroyに失敗するがその場合についてはshowアクションを参照
      end
    end
end
