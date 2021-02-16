require 'rails_helper'

RSpec.describe MessageChannel, type: :channel do
  before do
    # `stub_connection`は、渡されたidで
    # Connectionインスタンスを初期化する 
    stub_connection 
    @chat_group = create(:chat_group)
  end

  describe "subscribe" do
    context "subscribe失敗" do
      it "groupのidがないとsubscribeできない" do
        subscribe
        expect(subscription).to be_confirmed
        expect(subscription).not_to have_streams
      end

      it "rejects when room id is invalid" do
        subscribe(chat_group_id: -1)
    
        expect(subscription).to be_rejected
      end
    end
    
  end
  
end
