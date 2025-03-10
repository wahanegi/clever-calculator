FactoryBot.define do 
    factory :item_pricing do 
        association :item
        default_fixed_price { Faker::Commerce.price(range: 10.0..100.0) }
        fixed_parameters{ {} }
        is_selectable_options { false }
        pricing_options { {} }
        is_open { false }
        open_parameters_label { [] }
        formula_parameters { {} }
        calculation_formula { nil }
    end
end