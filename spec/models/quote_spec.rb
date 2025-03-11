require 'rails_helper'

RSpec.describe Quote, type: :model do
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
end
