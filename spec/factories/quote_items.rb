FactoryBot.define do
  factory :quote_item do
    association :quote
    association :item
    price { 0 }
    discount { 0 }
    final_price { price }
    pricing_parameters { {} }
  end
end
