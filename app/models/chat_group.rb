class ChatGroup < ApplicationRecord
  validates :group_name, presence: true
end
