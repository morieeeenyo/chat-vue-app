class CreateChatGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_groups do |t|
      t.string :group_name, null: false, defalut: ""
      t.timestamps
    end
  end
end
