FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    admin { false }
  end

  trait :admin do
    admin { true }
  end
end
