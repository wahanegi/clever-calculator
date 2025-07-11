FactoryBot.define do
  factory :contract_type do
    name { Faker::Team.unique.name }
  end
end
