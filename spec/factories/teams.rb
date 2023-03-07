FactoryBot.define do
  factory :team do
    name { Faker::Team.name }
    acronym { Faker::Team.name[0..5].delete(' ') }
  end
end
