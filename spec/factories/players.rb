FactoryBot.define do
  factory :player do
    association :team

    name { Faker::Name.name }
    number { Faker::Number.between(from: 1, to: 11) }
    nationality { Faker::Nation.nationality }
    age { Faker::Number.between(from: 16, to: 40) }
    position { %w[A D M G].sample }
  end
end
