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
        
        binding.pry
        
        expect(subscription).not_to have_streams
      end
    end
    
  end
  
end
