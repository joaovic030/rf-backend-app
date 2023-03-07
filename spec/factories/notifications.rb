FactoryBot.define do
  factory :notification do
    player
    message { Faker::Lorem.paragraph }
  end
end
