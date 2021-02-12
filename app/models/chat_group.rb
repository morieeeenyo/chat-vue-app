class ChatGroup < ApplicationRecord
  validates :group_name, presence: true
  has_many :messages, dependent: :destroy
end
