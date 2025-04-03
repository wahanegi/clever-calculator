require 'rails_helper'

RSpec.describe Customer, type: :model do
  subject { build(:customer) }

  describe 'associations' do
    it { is_expected.to have_many(:quotes).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to be_valid }

    context 'company_name' do
      it { is_expected.to validate_presence_of(:company_name) }
      it { is_expected.to validate_uniqueness_of(:company_name).case_insensitive }
    end
  end

  describe '#full_name' do
    it 'returns the full name of the customer' do
      subject.first_name = 'John'
      subject.last_name = 'Doe'
      expect(subject.full_name).to eq('John Doe')
    end

    it 'returns an empty string if both first and last names are blank' do
      subject.first_name = ''
      subject.last_name = ''
      expect(subject.full_name).to eq('')
    end
  end
end
