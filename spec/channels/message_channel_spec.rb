require 'rails_helper'

RSpec.describe MessageChannel, type: :channel do
  before do
    # `stub_connection`は、渡されたidでConnectionインスタンスを初期化する 
    @chat_group = create(:chat_group)
    stub_connection 
  end

  describe "subscribe" do
    context "subscription成功" do
      it "正しいグループのidがあればsubscriptionに成功する" do
          subscribe(chat_group_id: @chat_group.id)
          expect(subscription).to be_confirmed
          # check particular stream by name
          expect(subscription).to have_stream_from("message_channel_#{@chat_group.id}")
      end
    end

    context "subscribe失敗" do
      it "groupのidがないとsubscribeできない" do
        subscribe
        expect(subscription).to be_rejected
      end

      it "不正なidでアクセスした場合にはsubscribeできない" do
        subscribe(chat_group_id: -1)
        expect(subscription).to be_rejected
      end
    end
    
  end

  describe "メッセージの送信" do
    before do
      @message = build(:message, chat_group_id: @chat_group.id) #postメソッド内でメッセージを保存するのでここではbuildするだけ
    end
    
    context "送信成功" do
      it "グループが選択されている状態でメッセージを送信するとメッセージが一つDBに保存される" do
          subscribe(chat_group_id: @chat_group.id)
          expect(subscription).to be_confirmed
          expect { 
           perform :post, message: @message.text
          }. to change(Message, :count).by(1) 
      end

      it "グループが選択されている状態でメッセージを送信するとメッセージが接続しているチャネルに配信される" do
          subscribe(chat_group_id: @chat_group.id)
          expect(subscription).to be_confirmed
          expect { 
           perform :post, message: @message.text
          }. to have_broadcasted_to("message_channel_#{@chat_group.id}").with{ |data|
            expect(data['message']['text']).to eq @message.text
            expect(data['message']['id']).not_to eq nil #保存されたデータであればidは存在している
          }
      end
    end 

    context "送信失敗" do
      it "グループが選択されていない状態でメッセージを送信するとメッセージが保存できない" do
          subscribe(chat_group_id: nil)
          expect { 
           perform :post, message: @message.text
          }. to raise_error RuntimeError #Must be subscribed! というエラーが出ることを検証
      end

      it "textが空の場合メッセージが保存されない" do
          subscribe(chat_group_id: @chat_group.id)
          expect(subscription).to be_confirmed
          expect {
            expect { 
             perform :post, message: nil
            }.to raise_error ActiveRecord::RecordInvalid #サーバー側で例外を発生させる
          }.to change(Message, :count).by(0)  #空のメッセージを送るとデータが保存されずメッセージの数が増えない
      end

      it "textが空の場合メッセージがbroadcastされない" do
          subscribe(chat_group_id: @chat_group.id)
          expect(subscription).to be_confirmed
          expect {
            expect { 
             perform :post, message: nil
            }.to raise_error ActiveRecord::RecordInvalid #サーバー側で例外を発生させる
          }.not_to have_broadcasted_to("message_channel_#{@chat_group.id}") #空のメッセージを送るとデータがbroadcastされていない
      end
    end
  end

end
