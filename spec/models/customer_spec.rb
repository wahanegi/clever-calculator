require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'validations' do
    let(:customer) { build(:customer) }
    it('should be valid') { expect(customer).to be_valid }

    describe 'company_name' do
      let(:customer_created) { create(:customer) }

      it { should validate_presence_of(:company_name) }

      it do
        customer_created
        customer.company_name = customer_created.company_name

        expect(customer).not_to be_valid
        expect(customer.errors[:company_name]).to include('has already been taken')
      end
    end

    describe 'email' do
      let(:customer) { build(:customer) }

      it { should validate_presence_of(:email) }

      it('should not allow invalid emails') do
        ['bob12', 'bob@gmail,com', 'bob@.com', 'bob12 bob@gmail.com'].each do |invalid_email|
          customer.email = invalid_email
          expect(customer).not_to be_valid
          expect(customer.errors[:email]).to include('must be a valid email address')
        end
      end
    end

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:position) }
    it { should validate_presence_of(:address) }
  end
end
