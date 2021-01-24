require 'rails_helper'

RSpec.describe "ChatGroups", type: :request do
  before do
    @chat_group = build(:chat_group).attributes #paramsとして送るために.attributesを使用。
  end
  
  describe "api/v1/chat_groups#create" do
    context "パラメータが正しいとき" do
      it "リクエストが成功すること" do
        post api_v1_chat_groups_path, params: { chat_group: @chat_group  }
        expect(response).to have_http_status(201) #リソースを保存する処理の成功時のステータスは201
      end
  
      it "chat_groupsテーブルに一つデータが追加されること" do
        expect do  #長いのでブロックで引数に渡してます
         post api_v1_chat_groups_path, params: { chat_group: @chat_group  }
        end.to change(ChatGroup, :count).by(1) #ChatGroupモデルの数が1増えていることを検証
      end
  
      it "json形式で正しくデータが返却されること" do
        post api_v1_chat_groups_path, params: { chat_group: @chat_group  }
        json = JSON.parse(response.body) #返却されたデータをjson形式に変換
        expect(@chat_group[:group_name]).to eq json[:name]  #パラメータとして送った値とレスポンスの中身が合っているか検証
      end
    end

    context "パラメータが不正な場合" do
      before do
        @chat_group[:group_name] = nil #バリデーションに引っかかってエラーメッセージが返却されることを検証するためにgroup_nameを空にする。
      end
      
      it "リクエストに失敗すること" do
        post api_v1_chat_groups_path, params: { chat_group: @chat_group  }
        expect(response).to have_http_status(422) #不正なパラメータが送信された時、422でステータスコードが返ってくる
      end

      it "chat_groupsテーブルのデータが増えていないこと" do
        expect do  #長いのでブロックで引数に渡してます
          post api_v1_chat_groups_path, params: { chat_group: @chat_group  }
        end.to change(ChatGroup, :count).by(0) #ChatGroupモデルの数が増えていないことを検証
      end

      it "エラーメッセージがjson形式で返却されること" do
        post api_v1_chat_groups_path, params: { chat_group: @chat_group  }
        json = JSON.parse(response.body) #返却されたデータをjson形式に変換
        expect(json["errors"]).to include "Group name can't be blank" #コントローラーのエラーハンドリングでバリデーションに引っかかった場合はエラーメッセージを返すようにしている
      end
      
    end
    
  end
end
