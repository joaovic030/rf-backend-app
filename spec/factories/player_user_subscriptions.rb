FactoryBot.define do
  factory :player_user_subscription do
    association :player
    association :user
  end
end
