require 'rails_helper'

RSpec.describe QuoteItem, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:quote).required }
    it { is_expected.to belong_to(:item).required }
    it { is_expected.to belong_to(:item_pricing).required }
    it { is_expected.to have_many(:notes).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }

    it do
      is_expected.to validate_numericality_of(:discount).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100)
    end

    it { is_expected.to validate_presence_of(:final_price) }
    it { is_expected.to validate_numericality_of(:final_price).is_greater_than_or_equal_to(0) }
  end

  describe 'before_save callbacks' do
    let(:quote) { create(:quote) }
    let(:item) { create(:item, pricing_type: :open) }
    let(:item_pricing) { create(:item_pricing, item: item) }
    let(:price) { 1000 }
    let(:discount) { 10 }

    context 'when quote_item is created' do
      let(:quote_item) do
        QuoteItem.new(quote: quote, item_pricing: item_pricing, item: item, price: price, discount: discount)
      end

      it 'calculates final_price before saving' do
        quote_item.save
        expect(quote_item.final_price).to eq(900)
      end
    end

    context 'when quote_item is updated' do
      let(:quote_item) do
        create(:quote_item, quote: quote, item_pricing: item_pricing, item: item, price: price, discount: discount)
      end

      context 'when price changes' do
        before do
          quote_item.price = BigDecimal(1200)
          quote_item.save
        end

        it 'recalculates final_price' do
          expect(quote_item.final_price).to eq(1080)
        end

        it 'calls calculate_final_price' do
          expect_any_instance_of(QuoteItem).to_not receive(:calculate_final_price)
        end
      end

      context 'when discount changes' do
        before do
          quote_item.discount = BigDecimal(20)
          quote_item.save
        end

        it 'recalculates final_price' do
          expect(quote_item.final_price).to eq(800)
        end

        it 'calls calculate_final_price' do
          expect_any_instance_of(QuoteItem).to_not receive(:calculate_final_price)
        end
      end

      context 'when neither price nor discount changes' do
        before do
          quote_item.save
        end

        it 'does not recalculate final_price' do
          expect(quote_item.final_price).to eq(900)
        end

        it 'does not recalculate final_price' do
          expect_any_instance_of(QuoteItem).to_not receive(:calculate_final_price)
        end
      end
    end
  end
end
