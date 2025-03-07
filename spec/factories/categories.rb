FactoryBot.define do
  factory :category do
    name { "Category" }
    description { "Default description" }
    is_disabled { false }
  end
end
