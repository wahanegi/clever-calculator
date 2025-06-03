FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    category { association :category }
    fixed_parameters { {} }
    pricing_options { {} }
    is_disabled { false }
    is_fixed { false }
    is_open { false }
    is_selectable_options { false }
    open_parameters_label { [] }
    formula_parameters { [] }
    calculation_formula { nil }

    trait :with_fixed_parameters do
      fixed_parameters { { "Acquisition" => "2500" } }
      is_fixed { true }
      formula_parameters { ["Acquisition"] }
      calculation_formula { DentakuKeyEncoder.encode "Acquisition" }
    end

    trait :with_pricing_options do
      pricing_options do
        {
          "Tier" => {
            "1-5" => "100",
            "6-15" => "200",
            "16+" => "350"
          }
        }
      end
      is_selectable_options { true }
      formula_parameters { ["Tier"] }
      calculation_formula { DentakuKeyEncoder.encode "Tier" }
    end

    trait :with_open_parameters do
      open_parameters_label { ["Custom"] }
      is_open { true }
      formula_parameters { ["Custom"] }
      calculation_formula { DentakuKeyEncoder.encode "Custom" }
    end

    trait :with_invalid_fixed_parameters do
      fixed_parameters { { "Acquisition" => "abc" } }
    end

    trait :with_invalid_pricing_options do
      pricing_options { { "Tier" => { "1-5" => "abc" } } }
    end

    trait :with_disabled_category do
      category { association :category, :disabled }
    end

    trait :without_calculation_formula do
      calculation_formula { nil }
    end
  end
end
