require 'rails_helper'

RSpec.describe "ChatGroups", type: :system do
  before do
    @chat_group = build(:chat_group)
  end
  

  context "グループ新規作成" do
    it "グループ名を入力して作成ボタンを押すと非同期でグループが作成され、作成したチャットグループのページに遷移すること" do 
      visit root_path
      expect(page).to  have_selector '.btn-circle-flat'
      click_button '+'
      expect(page).to  have_content 'チャットグループ新規作成'
      fill_in "group_name_input",	with: @chat_group.group_name
      expect do 
        click_button '作成'
        sleep 1
      end.to change(ChatGroup, :count).by(1)
      expect(page).to  have_content @chat_group.group_name
    end
    
  end
  

  
end
