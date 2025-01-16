FactoryBot.define do
  factory :admin_user do
    email { Faker::Internet.unique.email }
    name { Faker::Internet.username.gsub(/[^a-zA-Z0-9_]/, '') }
    password { '@password' }
    password_confirmation { '@password' }
  end
end
