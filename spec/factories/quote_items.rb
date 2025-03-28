FactoryBot.define do
  factory :quote_item do
    association :quote, factory: :quote
    association :item, factory: :item
    association :item_pricing, factory: :item_pricing
    price { 100.00 }
    discount { 10 }
    open_parameters { {} }
  end
end
