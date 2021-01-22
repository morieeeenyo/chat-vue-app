require 'rails_helper'

RSpec.describe ChatGroup, type: :model do
  before do
    @chat_group = build(:chat_group)
  end

  context "chat_groupが登録できるとき" do
    it "group_nameがあれば登録できる" do
      expect(@chat_group).to be_valid
    end
  end

  context "chat_groupが登録できないとき" do
    it "group_nameが空では登録できないこと" do
      @chat_group.group_name = ""
      @chat_group.valid?
      expect(@chat_group.errors.full_messages).to include "Group name can't be blank"  
    end
  end

end
