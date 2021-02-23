class Message < ApplicationRecord
  belongs_to :chat_group
  validates :text, presence: true
end
