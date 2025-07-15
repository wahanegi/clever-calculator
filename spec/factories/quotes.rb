FactoryBot.define do
  factory :quote do
    association :user, factory: :user
    association :customer, factory: :customer
    association :contract_type, factory: :contract_type
    total_price { 0 }
    contract_start_date { Time.zone.today }
    contract_end_date { Time.zone.today + 30 }
  end
end
