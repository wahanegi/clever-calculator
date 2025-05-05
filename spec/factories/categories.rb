FactoryBot.define do
  factory :category do
    name { Faker::Team.unique.name }
    description { Faker::Food.description }
    is_disabled { false }

    trait :disabled do
      is_disabled { true }
    end
  end
end
