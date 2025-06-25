require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  subject { build(:admin_user) }

  context 'factory' do
    it 'is expect to have valid factory' do
      expect(subject).to be_valid
    end
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

    describe 'administrator' do
      it { is_expected.to allow_value(false).for(:administrator) }
      it { is_expected.to allow_value(true).for(:administrator) }

      context 'when administrator is true' do
        before { subject.administrator = true }

        it 'does not allow more than one administrator' do
          create(:admin_user, administrator: true)
          expect(subject).not_to be_valid
          expect(subject.errors[:administrator]).to include('can only be assigned to one admin user at a time')
        end
      end

      context 'when administrator is false' do
        before { subject.administrator = false }

        it 'does not validate only one administrator' do
          create(:admin_user, administrator: false)
          expect(subject).to be_valid
        end
      end
    end
  end
end
