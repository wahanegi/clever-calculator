require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:item)).to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:category).optional }
  end

  describe 'validations' do
    subject { build(:item) }

    describe 'name' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_uniqueness_of(:name).scoped_to(:category_id).with_message('Item name must be unique within category') }
      it { is_expected.to validate_length_of(:name).is_at_most(50) }

      it 'allows same name with different categories' do
        category1 = create(:category)
        category2 = create(:category)
        create(:item, name: 'Test Item', category: category1)
        item2 = build(:item, name: 'Test Item', category: category2)
        expect(item2).to be_valid
      end
    end

    describe 'category_must_be_active' do
      it 'is valid with an active category' do
        item = build(:item)
        expect(item).to be_valid
      end

      it 'is valid without a category' do
        item = build(:item, category: nil)
        expect(item).to be_valid
      end

      it 'is invalid with a disabled category' do
        item = build(:item, :with_disabled_category)
        expect(item).not_to be_valid
        expect(item.errors[:category]).to include('is disabled')
      end
    end

    describe 'calculation_formula' do
      context 'when is_fixed is true' do
        let(:item) { build(:item, :with_fixed_parameters, :without_calculation_formula) }

        it 'requires calculation_formula' do
          expect(item).not_to be_valid
          expect(item.errors[:calculation_formula]).to include("can't be blank")
        end
      end

      context 'when is_open is true' do
        let(:item) { build(:item, :with_open_parameters, :without_calculation_formula) }

        it 'requires calculation_formula' do
          expect(item).not_to be_valid
          expect(item.errors[:calculation_formula]).to include("can't be blank")
        end
      end

      context 'when is_selectable_options is true' do
        let(:item) { build(:item, :with_pricing_options, :without_calculation_formula) }

        it 'requires calculation_formula' do
          expect(item).not_to be_valid
          expect(item.errors[:calculation_formula]).to include("can't be blank")
        end
      end

      context 'when multiple flags are true' do
        let(:item) do
          build(:item,
                fixed_parameters: { "Aquisition" => "2500" },
                pricing_options: { "Tier" => { "1-5" => "100" } },
                is_fixed: true,
                is_selectable_options: true,
                calculation_formula: nil)
        end

        it 'requires calculation_formula' do
          expect(item).not_to be_valid
          expect(item.errors[:calculation_formula]).to include("can't be blank")
        end
      end

      context 'when no flags are true' do
        it 'does not require calculation_formula' do
          item = build(:item)
          expect(item).to be_valid
        end
      end

      context 'when calculation_formula is present' do
        let(:item) do
          build(:item,
                is_fixed: true,
                formula_parameters: %w[param1 param2],
                calculation_formula: 'param1 + param2 * 123')
        end

        it 'is valid with correct formula' do
          expect(item).to be_valid
        end

        it 'is invalid if all formula_parameters are missing in formula' do
          item.calculation_formula = 'param1 + 123 + param212'
          expect(item).not_to be_valid
          expect(item.errors[:calculation_formula]).to include('is missing parameters: param2')
        end

        it 'is invalid with unrecognized parameters' do
          item.calculation_formula = 'param1 + abc * 123'
          expect(item).not_to be_valid
          expect(item.errors[:calculation_formula]).to include('contains invalid parameters: abc')
        end

        it 'is valid with numbers, operators, and formula_parameters' do
          item.calculation_formula = 'param1 + ( 2 * param2 )'
          expect(item).to be_valid
        end
      end
    end

    describe 'fixed_parameters' do
      it 'is valid with empty hash' do
        item = build(:item, fixed_parameters: {})
        expect(item).to be_valid
      end

      it 'is valid with numeric string values' do
        item = build(:item, :with_fixed_parameters)
        expect(item).to be_valid
      end

      it 'is valid with numeric values' do
        item = build(:item, fixed_parameters: { "Acquisition" => 2500 })
        expect(item).to be_valid
      end

      it 'is invalid with non-numeric string values' do
        item = build(:item, :with_invalid_fixed_parameters)
        expect(item).not_to be_valid
        expect(item.errors[:fixed_parameters]).to include("value for 'Acquisition' must be a number")
      end

      it 'is invalid with non-hash values' do
        item = build(:item, fixed_parameters: "not_a_hash")
        expect(item).not_to be_valid
        expect(item.errors[:fixed_parameters]).to include("must be a JSON object")
      end
    end

    describe 'pricing_options' do
      it 'is valid with empty hash' do
        item = build(:item, pricing_options: {})
        expect(item).to be_valid
      end

      it 'is valid with nested numeric string values' do
        item = build(:item, :with_pricing_options)
        expect(item).to be_valid
      end

      it 'is valid with nested numeric values' do
        item = build(:item, pricing_options: { "Tier" => { "1-5" => 100 } })
        expect(item).to be_valid
      end

      it 'is invalid with non-numeric nested string values' do
        item = build(:item, :with_invalid_pricing_options)
        expect(item).not_to be_valid
        expect(item.errors[:pricing_options]).to include("value for 'Tier -> 1-5' must be a number")
      end

      it 'is invalid with non-hash values' do
        item = build(:item, pricing_options: "not_a_hash")
        expect(item).not_to be_valid
        expect(item.errors[:pricing_options]).to include("must be a JSON object")
      end
    end
  end
end
