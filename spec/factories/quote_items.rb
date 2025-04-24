FactoryBot.define do
  factory :quote_item do
    association :quote, factory: :quote
    association :item, factory: :item
    price { 100.00 }
    discount { 10 }
    pricing_parameters { {} }
  end
end
