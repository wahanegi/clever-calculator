FactoryBot.define do 
    factory :item do 
        name { Faker::Commerce.product_name }
        description { Faker::Lorem.paragraph }
        pricing_type { :fixed }
        is_disabled { false }

        association :category
    end
end
