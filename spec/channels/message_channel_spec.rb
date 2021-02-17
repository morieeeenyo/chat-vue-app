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
      @message = build(:message, chat_group_id: @chat_group.id)
    end
    
    context "送信成功" do
      it "グループが選択されていればメッセージが送信できる" do
          subscribe(chat_group_id: @chat_group.id)
          expect(subscription).to be_confirmed
          perform :post, data: @message.text
          expect(transmissions.last).to eq(message: @message)
      end
      
    end
    
  end
  
end
