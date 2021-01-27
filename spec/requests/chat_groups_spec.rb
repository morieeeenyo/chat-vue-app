require 'rails_helper'

RSpec.describe "ChatGroups", type: :request do
  before do
    @chat_group = build(:chat_group) 
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
        expect(@chat_group_params['group_name']).to eq json['group']['group_name']  
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
        get api_v1_chat_group_path(@chat_group), xhr: true
        json = JSON.parse(response.body)        
        #送ったパラメータとレスポンスのデータが一致しているか検証
        expect(@chat_group['id']).to eq json['id']
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
  
end
