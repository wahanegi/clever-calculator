require 'rails_helper'

RSpec.describe Quote, type: :model do
  subject { build(:quote) }

  describe 'factories' do
    it 'has a valid factory' do
      expect(subject).to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:customer).required }
    it { is_expected.to belong_to(:user).required }
    it { is_expected.to have_many(:quote_items).dependent(:destroy) }
    it { is_expected.to have_many(:items).through(:quote_items) }
    it { is_expected.to have_many(:categorizations).dependent(:destroy) }
    it { is_expected.to have_many(:categories).through(:categorizations) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:total_price) }
    it { is_expected.to validate_numericality_of(:total_price).is_greater_than_or_equal_to(0) }

    it 'is invalid without a customer' do
      quote = build(:quote, customer: nil)
      quote.valid?
      expect(quote.errors[:customer]).to include('must exist')
    end

    it 'is invalid without a user' do
      quote = build(:quote, user: nil)
      quote.valid?
      expect(quote.errors[:user]).to include('must exist')
    end
  end

  describe 'scopes' do
    let!(:quote1) { create(:quote, step: 'completed') }
    let!(:quote2) { create(:quote, step: 'customer_info') }
    let!(:quote3) { create(:quote, step: 'items_pricing') }

    describe '.completed' do
      it 'returns only completed quotes' do
        expect(Quote.completed).to contain_exactly(quote1)
      end
    end

    describe '.unfinished' do
      it 'returns only unfinished quotes' do
        expect(Quote.unfinished).to contain_exactly(quote2, quote3)
      end
    end

    describe '.last_unfinished' do
      it 'returns the most recent unfinished quote' do
        quote2.update!(created_at: 1.day.ago)
        quote3.update!(created_at: Time.current)
        expect(Quote.last_unfinished).to eq(quote3)
      end
    end
  end

  describe '#recalculate_total_price' do
    let!(:quote) { create(:quote, total_price: 0) }

    before do
      create(:quote_item, quote: quote, price: 100, discount: 0)
      create(:quote_item, quote: quote, price: 50, discount: 0)
    end

    it 'updates the total_price based on associated quote_items' do
      quote.recalculate_total_price
      expect(quote.total_price).to eq(150)
    end
  end
end
