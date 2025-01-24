FactoryBot.define do
  factory :admin_user do
    email { Faker::Internet.unique.email }
    name { Faker::Name.name }
    password { '@password' }
    password_confirmation { '@password' }
  end
end
