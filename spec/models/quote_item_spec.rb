require 'rails_helper'

RSpec.describe QuoteItem, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:quote).required }
    it { is_expected.to belong_to(:item).required }
    it { is_expected.to have_one(:note).dependent(:destroy) }
  end

  describe 'validations' do
    it 'adds a custom error if price is nil' do
      quote_item = build(:quote_item, price: nil, discount: 10, final_price: 0, item: build(:item), quote: build(:quote))
      quote_item.valid?
      expect(quote_item.errors[:price]).to include("Could not be calculated – please make sure all required parameters are filled in")
    end
    it 'validates that price is a number greater than or equal to 0' do
      quote_item = build(:quote_item, price: -1, quote: build(:quote), item: build(:item))
      quote_item.valid?
      expect(quote_item.errors[:price]).to include("Must be a valid number between 0 and 99999999.99 (check your parameter inputs)")
    end
    it { is_expected.to validate_numericality_of(:discount).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100) }
    it { is_expected.to validate_presence_of(:final_price) }
    it { is_expected.to validate_numericality_of(:final_price).is_greater_than_or_equal_to(0) }

    context 'boundary values' do
      subject(:quote_item) { build(:quote_item, price: 100, discount: 10) }

      it 'is valid with price = 0' do
        subject.price = 0
        subject.valid?
        expect(subject).to be_valid
      end

      it 'is invalid with price < 0' do
        subject.price = -1
        subject.valid?
        expect(subject).not_to be_valid
        expect(subject.errors[:price]).to include("Must be a valid number between 0 and 99999999.99 (check your parameter inputs)")
      end

      it 'is valid with discount = 0' do
        subject.discount = 0
        expect(subject).to be_valid
      end

      it 'is valid with discount = 100' do
        subject.discount = 100
        expect(subject).to be_valid
      end

      it 'is invalid with discount < 0' do
        subject.discount = -0.1
        expect(subject).not_to be_valid
        expect(subject.errors[:discount]).to include("must be greater than or equal to 0")
      end

      it 'is invalid with discount > 100' do
        subject.discount = 100.1
        expect(subject).not_to be_valid
        expect(subject.errors[:discount]).to include("must be less than or equal to 100")
      end

      it 'is valid with final_price = 0' do
        allow(subject).to receive(:calculate_final_price)
        subject.final_price = 0
        expect(subject).to be_valid
      end

      it 'is invalid with final_price < 0' do
        allow(subject).to receive(:calculate_final_price)
        subject.final_price = -1
        expect(subject).not_to be_valid
        expect(subject.errors[:final_price]).to include("must be greater than or equal to 0")
      end
    end
  end

  describe 'before_validation callbacks' do
    let(:quote) { create(:quote) }
    let(:item) { create(:item) }
    let(:price) { 1000 }
    let(:discount) { 10 }

    describe '#compile_pricing_parameters' do
      let(:quote_item) { build(:quote_item, quote: quote, item: item) }

      it 'combines fixed, open, and select parameters correctly' do
        item.update(
          fixed_parameters: { 'platform_fee' => '1000' },
          open_parameters_label: ['setup'],
          pricing_options: { 'tier' => %w[basic premium] }
        )

        quote_item.open_param_values = { 'setup' => '2500' }
        quote_item.select_param_values = { 'tier' => '500' }

        quote_item.valid?

        expect(quote_item.pricing_parameters).to eq({
                                                      'platform_fee' => '1000', 'setup' => '2500', 'tier' => '500'
                                                    })
      end

      it 'handles nil open_param_values' do
        item.update(
          fixed_parameters: { 'platform_fee' => '1000' },
          pricing_options: { 'tier' => %w[basic premium] }
        )

        quote_item.open_param_values = nil
        quote_item.select_param_values = { 'tier' => '500' }

        quote_item.valid?

        expect(quote_item.pricing_parameters).to eq({
                                                      'platform_fee' => '1000', 'tier' => '500'
                                                    })
      end
    end

    describe '#calculate_price_from_formula' do
      let(:quote_item) { build(:quote_item, quote: quote, item: item) }

      it 'evaluates the formula using Dentaku' do
        item.update(
          calculation_formula: 'users * setup',
          fixed_parameters: { 'users' => 10 },
          open_parameters_label: ['setup']
        )

        quote_item.open_param_values = { 'setup' => 500 }

        quote_item.valid?

        expect(quote_item.price).to eq(5000)
      end

      it 'adds error for missing variables' do
        item.update(calculation_formula: 'users * setup', fixed_parameters: {})
        quote_item.open_param_values = {}

        quote_item.valid?

        expect(quote_item.errors[:price]).to include("Could not be calculated – please make sure all required parameters are filled in")
      end
    end

    describe '#calculate_final_price' do
      let(:quote_item) { build(:quote_item, quote: quote, item: item, price: price, discount: discount) }

      context 'when price and discount are present' do
        it 'calculates final_price on create' do
          quote_item.save
          expect(quote_item.final_price).to eq(900)
        end

        it 'recalculates final_price when price changes' do
          quote_item.save
          quote_item.price = 1200
          quote_item.save
          expect(quote_item.final_price).to eq(1080)
        end

        it 'recalculates final_price when discount changes' do
          quote_item.save
          quote_item.discount = 20
          quote_item.save
          expect(quote_item.final_price).to eq(800)
        end
      end
    end
  end

  describe '#item_requires_formula?' do
    let(:quote_item) { build(:quote_item, item: item) }
    let(:item) { build(:item) }

    it 'returns true when item has a calculation formula' do
      item.calculation_formula = 'users * setup'
      expect(quote_item.send(:item_requires_formula?)).to be true
    end

    it 'returns false when item has no calculation formula' do
      item.calculation_formula = nil
      expect(quote_item.send(:item_requires_formula?)).to be false
    end

    it 'returns false when item is nil' do
      quote_item.item = nil
      expect(quote_item.send(:item_requires_formula?)).to be false
    end
  end

  describe 'pricing_parameters storage' do
    let(:quote) { create(:quote) }
    let(:item) { create(:item, fixed_parameters: { 'platform_fee' => '1000' }, open_parameters_label: ['setup']) }
    let(:quote_item) { create(:quote_item, quote: quote, item: item, open_param_values: { 'setup' => '2500' }) }

    it 'persists pricing_parameters in the database' do
      quote_item.valid?
      quote_item.save
      expect(QuoteItem.find(quote_item.id).pricing_parameters).to eq({
                                                                       'platform_fee' => '1000', 'setup' => '2500'
                                                                     })
    end
  end

  describe 'quote total price recalculation' do
    let(:quote) { create(:quote, total_price: 0) }
    let(:item) { create(:item) }

    it 'triggers after save and updates quote total_price' do
      quote_item = build(:quote_item, quote: quote, item: item, price: 100, discount: 0, final_price: 100)
      expect(quote).to receive(:recalculate_total_price).and_call_original
      quote_item.save
      expect(quote.reload.total_price).to eq(100)
    end

    it 'triggers after destroy and updates quote total_price' do
      quote_item = create(:quote_item, quote: quote, item: item, price: 100, discount: 0, final_price: 100)
      quote.update(total_price: 100)
      expect(quote).to receive(:recalculate_total_price).and_call_original
      quote_item.destroy
      expect(quote.reload.total_price).to eq(0)
    end
  end
end
