require 'rails_helper'

RSpec.describe ItemPricing, type: :model do
  let(:item) { create(:item) }
  let(:item_pricing) { build(:item_pricing, item: item) }

  describe "associations" do
    it { should belong_to(:item) }
  end

  describe "validations" do
    it { should validate_numericality_of(:default_fixed_price).is_greater_than_or_equal_to(0).allow_nil }

    context "when pricing_type is 'fixed_open'" do
      it "validates presence of calculation_formula" do
        item.pricing_type = "fixed_open"
        item_pricing.calculation_formula = nil
        expect(item_pricing).not_to be_valid
        expect(item_pricing.errors[:calculation_formula]).to include("can't be blank")
      end
    end

    context "when is_open is false" do
      it "validates presence of default_fixed_price" do
        item_pricing.is_open = false
        item_pricing.default_fixed_price = nil
        expect(item_pricing).not_to be_valid
        expect(item_pricing.errors[:default_fixed_price]).to include("can't be blank")
      end
    end

    context "default values" do
      it "sets default values for JSONB fields" do
        item_pricing = create(:item_pricing)
        expect(item_pricing.fixed_parameters).to eq({})
        expect(item_pricing.pricing_options).to eq({})
        expect(item_pricing.formula_parameters).to eq({})
        expect(item_pricing.open_parameters_label).to eq([])
      end
    end
    
    
    context "when is_open is true" do
      it "allows default_fixed_price to be nil" do
        item_pricing.is_open = true
        item_pricing.default_fixed_price = nil
        expect(item_pricing).to be_valid
      end
    end
     
    context "when calculation_formula is present" do
      it "accepts valid formula strings" do
        item_pricing.calculation_formula = "base_price * multiplier"
        expect(item_pricing).to be_valid
      end
    end
      
  end
end
