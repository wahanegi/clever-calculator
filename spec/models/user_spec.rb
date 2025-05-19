require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  context 'factory' do
    it 'is expect to have valid factory' do
      expect(subject).to be_valid
    end
  end

  context 'Associations' do
    it { is_expected.to have_many(:quotes).dependent(:destroy) }
  end
  context 'Validations' do
    describe 'name' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to allow_value('bob').for(:name) }
    end

    describe 'email' do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to allow_value('bob@example.com').for(:email) }

      invalid_emails = ['bob', 'bob@gmail,com', 'bob@.com', 'bob bob@gmail.com']
      invalid_emails.each do |email|
        it { is_expected.not_to allow_value(email).for(:email).with_message('must be a valid email format') }
      end
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end

    describe 'phone' do
      it { is_expected.to allow_value(nil).for(:phone) }
      it { is_expected.to allow_value('').for(:phone) }
      it { is_expected.to allow_value('+1234567890').for(:phone) }
      it { is_expected.to allow_value('123-456-7890').for(:phone) }
      it { is_expected.to allow_value('123 456 7890').for(:phone) }

      it {
        is_expected.not_to allow_value('abc123').for(:phone)
                                                .with_message('must be a valid phone number (digits, spaces, or dashes only, optional + at start)')
      }

      it {
        is_expected.not_to allow_value('+123!456@7890').for(:phone)
                                                       .with_message('must be a valid phone number (digits, spaces, or dashes only, optional + at start)')
      }
    end

    describe 'password' do
      it { is_expected.to validate_presence_of(:password) }
      it { is_expected.to validate_length_of(:password).is_at_least(8) }
      it { is_expected.to allow_value('@password').for(:password) }
      it {
        is_expected.not_to allow_value('passsword!').for(:password).with_message('must not contain repeated characters')
      }
      it { is_expected.not_to allow_value('password').for(:password).with_message('must contain at least one symbol') }
      it {
        is_expected.not_to allow_value('!23456').for(:password).with_message('is too short (minimum is 8 characters)')
      }
      it 'does not allow a password longer than 128 characters' do
        long_password = 'a' * 129
        is_expected.not_to allow_value(long_password).for(:password)
                                                     .with_message('is too long (maximum is 128 characters)')
      end
    end
  end
end
