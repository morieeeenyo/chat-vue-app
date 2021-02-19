require 'rails_helper'

RSpec.describe Message, type: :model do
  before do
    @message = build(:message)
  end

  context "messageが登録できるとき" do
    it "textとchat_group_idがあれば登録できる" do
      expect(@message).to be_valid
    end
  end

  context "messageが登録できないとき" do
    it "textが空では登録できないこと" do
      @message.text = ""
      @message.valid?
      expect(@message.errors.full_messages).to include "Text can't be blank"  
    end

    it "メッセージに紐づくグループがなければ登録できないこと" do
      @message.chat_group = nil
      @message.valid?
      expect(@message.errors.full_messages).to include "Chat group must exist"  
    end
  end
end
