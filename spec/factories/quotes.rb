FactoryBot.define do
  factory :quote do
    association :user, factory: :user
    association :customer, factory: :customer
    total_price { 0 }
  end
end
