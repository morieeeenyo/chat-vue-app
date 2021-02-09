module SelectGroupSupport 
  def select_group(group)
    # 非同期でのグループ情報の取得はここに含めている
    group.save
    visit root_path
    click_link group.group_name, href: "#/chat_groups/#{group.id}"
    expect(page).to  have_selector '#group-name', text: group.group_name
  end
end