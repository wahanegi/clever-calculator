require 'rails_helper'

RSpec.describe CustomerSerializer do
  subject { described_class.new(customer).serializable_hash }

  let(:customer) { create(:customer) }
  let(:expected_attributes) do
    {
      company_name: customer.company_name,
      email: customer.email,
      position: customer.position,
      address: customer.address,
      notes: customer.notes,
      first_name: customer.first_name,
      last_name: customer.last_name,
      full_name: customer.full_name
    }
  end

  describe 'serializable_hash' do
    it 'returns the correct attributes' do
      expect(subject[:data][:attributes]).to include(expected_attributes)
    end

    it 'returns the correct type' do
      expect(subject[:data][:type]).to eq(:customer)
    end

    it 'returns the correct id' do
      expect(subject[:data][:id]).to eq(customer.id.to_s)
    end
  end
end
