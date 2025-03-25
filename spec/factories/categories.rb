FactoryBot.define do
  factory :category do
    name { Faker::Team.unique.name }
    description { Faker::Food.description }
    is_disabled { false }
  end
end
