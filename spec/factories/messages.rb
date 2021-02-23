FactoryBot.define do
  factory :message do
    text {'test message'}
    association :chat_group
  end
end