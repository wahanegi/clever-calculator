FactoryBot.define do
  factory :customer do
    company_name { Faker::Company.unique.name }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    position { Faker::Job.title }
    address { Faker::Address.full_address }
    notes { Faker::Lorem.sentence }
  end
end
