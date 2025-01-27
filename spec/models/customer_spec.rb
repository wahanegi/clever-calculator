require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'validations' do
    let(:customer) { build(:customer) }

    it('should be valid') { expect(customer).to be_valid }

    describe 'company_name' do
      let(:customer_created) { create(:customer) }

      it { should validate_presence_of(:company_name) }

      context 'when company_name is not unique' do
        it do
          customer_created
          customer.company_name = customer_created.company_name

          expect(customer).not_to be_valid
          expect(customer.errors[:company_name]).to include('has already been taken')
        end
      end
    end
  end
end
