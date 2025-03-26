require 'rails_helper'

RSpec.describe Quote, type: :model do
  describe 'factory' do
    subject { build(:quote) }

    it 'is valid' do
      is_expected.to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:customer).required }
    it { is_expected.to belong_to(:user).required }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:total_price) }
    it { is_expected.to validate_numericality_of(:total_price).is_greater_than_or_equal_to(0) }
    it "is invalid without a customer" do
      quote = build(:quote, customer: nil)
      quote.valid?
      expect(quote.errors[:customer]).to include("must exist")
    end
    it "is invalid without a user" do
      quote = build(:quote, user: nil)
      quote.valid?
      expect(quote.errors[:user]).to include("must exist")
    end
  end

  describe 'scopes' do
    describe '.customer_name' do
      let!(:customer) { create(:customer, first_name: 'John', last_name: 'Doe', company_name: 'Apple') }
      let!(:quote) { create(:quote, customer: customer) }
      let!(:unscoped_customer) { create(:customer, first_name: 'Peter', last_name: 'Parker', company_name: 'Marvel') }
      let!(:unscoped_quote) { create(:quote, customer: unscoped_customer) }

      it 'returns the expected quote' do
        expect(described_class.customer_name('John')).to eq([quote])
        expect(described_class.customer_name('Doe')).to eq([quote])
        expect(described_class.customer_name('Apple')).to eq([quote])
      end
    end
  end
end
