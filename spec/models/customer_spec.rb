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

    context 'logo' do
      let!(:customer) { create(:customer) }
      let(:valid_logo) { fixture_file_upload(Rails.root.join("spec/fixtures/files/valid_logo.png"), 'image/png') }
      let(:invalid_logo) { fixture_file_upload(Rails.root.join("spec/fixtures/files/invalid_logo.svg"), 'image/svg+xml') }
      let(:large_size_logo) { fixture_file_upload(Rails.root.join("spec/fixtures/files/1_7_megabyte_logo.png"), 'image/png') }
      let(:logo_png) { fixture_file_upload(Rails.root.join("spec/fixtures/files/logo_type.png"), 'image/png') }
      let(:logo_jpeg) { fixture_file_upload(Rails.root.join("spec/fixtures/files/logo_type.jpeg"), 'image/jpeg') }

      it 'attaches a valid image' do
        customer.logo.attach(valid_logo)
        expect(customer.logo).to be_attached
      end

      it 'removes logo after purge' do
        customer.logo.attach(valid_logo)
        expect(customer.logo).to be_attached

        customer.logo.purge
        expect(customer.logo).not_to be_attached
      end

      it 'should be valid' do
        customer.logo.attach(valid_logo)
        expect(customer).to be_valid
      end

      it 'is invalid when the logo size is greater than 1 megabyte' do
        customer.logo.attach(large_size_logo)
        expect(customer).to be_invalid
        expect(customer.errors.messages_for(:logo)).to include('must be less than 1 megabyte')
      end

      it 'is invalid with a wrong file type' do
        customer.logo.attach(invalid_logo)
        expect(customer).to be_invalid
        expect(customer.errors.messages_for(:logo)).to include('must be a JPEG or PNG file')
      end

      it 'allows attach a PNG file' do
        customer.logo.attach(logo_png)
        expect(customer).to be_valid
        expect(customer.errors.messages_for(:logo)).to_not include('must be a JPEG or PNG file')
      end

      it 'allows attach a JPEG file' do
        customer.logo.attach(logo_jpeg)
        expect(customer).to be_valid
        expect(customer.errors.messages_for(:logo)).to_not include('must be a JPEG or PNG file')
      end
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
