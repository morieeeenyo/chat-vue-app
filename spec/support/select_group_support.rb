module SelectGroupSupport 
  def select_group(group)
    # インスタンスを保存し、リンクをクリックして非同期でグループ情報を取得
    visit root_path
    click_link group.group_name, href: "#/chat_groups/#{group.id}"
    expect(page).to  have_selector '#group-name', text: group.group_name
  end
end