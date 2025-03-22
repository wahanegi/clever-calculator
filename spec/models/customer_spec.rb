require 'rails_helper'

RSpec.describe Customer, type: :model do
  context 'validations' do
    subject { build(:customer) }

    it { is_expected.to be_valid }

    describe 'company_name' do
      it { is_expected.to validate_presence_of(:company_name) }
      it { is_expected.to validate_uniqueness_of(:company_name).case_insensitive }
    end
  end
end
