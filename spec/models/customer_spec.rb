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
      it { is_expected.to validate_length_of(:company_name).is_at_most(50) }
    end

    context 'logo' do
      let!(:customer) { create(:customer) }
      let(:valid_logo) { file_fixture('valid_logo.png') }
      let(:invalid_logo) { file_fixture('invalid_logo.svg') }
      let(:large_size_logo) { file_fixture('3_megabytes_logo.png') }
      let(:logo_png) { file_fixture('logo_type.png') }
      let(:logo_jpeg) { file_fixture('logo_type.jpeg') }

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

      it 'is invalid when the logo size is greater than 2 megabytes' do
        customer.logo.attach(large_size_logo)
        expect(customer).to be_invalid
        expect(customer.errors.messages_for(:logo)).to include('must be less than 2MB')
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

  describe '#small_logo' do
    let(:logo) { file_fixture('1000x1000px_logo.png') }
    let!(:customer) { create(:customer, logo: logo) }

    it 'returns a resized logo' do
      original_logo = Vips::Image.new_from_buffer(customer.logo.download, "")

      expect(original_logo.width).to eq(1000)
      expect(original_logo.height).to eq(1000)

      resized_logo = Vips::Image.new_from_buffer(customer.small_logo.download, "")

      expect(resized_logo.width).to be <= Customer::LOGO_RESIZE_LIMIT.first
      expect(resized_logo.height).to be <= Customer::LOGO_RESIZE_LIMIT.last
    end
  end
end
