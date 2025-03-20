require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:quotes).dependent(:destroy) }
  end

  describe 'validations' do
    let(:customer) { build(:customer) }

    it { is_expected.to be_valid }

    describe 'company_name' do
      it { is_expected.to validate_presence_of(:company_name) }
      it { is_expected.to validate_uniqueness_of(:company_name).case_insensitive }
    end
  end
end
