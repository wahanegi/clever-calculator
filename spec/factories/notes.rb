FactoryBot.define do
  factory :note do
    association :quote
    association :quote_item
    association :category
    notes { Faker::Lorem.paragraph }
    is_printable { false }
  end
end
