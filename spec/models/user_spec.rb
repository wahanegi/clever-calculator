require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it 'is expect to have valid factory' do
    expect(user).to be_valid
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to allow_value('bob@example.com').for(:email) }
    it { is_expected.not_to allow_value('bob').for(:email).with_message('must be a valid email format') }
    it { is_expected.not_to allow_value('bob@bob').for(:email).with_message('must be a valid email format') }
    it { is_expected.not_to allow_value('bob@gmail,com').for(:email).with_message('must be a valid email format') }
    it { is_expected.not_to allow_value('bob@.com').for(:email).with_message('must be a valid email format') }
    it { is_expected.not_to allow_value('bob bob@gmail.com').for(:email).with_message('must be a valid email format') }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to allow_value('bob').for(:name) }
    it { is_expected.not_to allow_value('@bob@').for(:name).with_message('must be alphanumeric') }

    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(8) }
    it { is_expected.to allow_value('@password').for(:password) }
    it { is_expected.not_to allow_value('password').for(:password).with_message('must contain at least one symbol') }
    it {
      is_expected.not_to allow_value('passsword!').for(:password).with_message('must not contain repeated characters')
    }
    it {
      is_expected.not_to allow_value('!23456').for(:password).with_message('is too short (minimum is 8 characters)')
    }

    it 'does not allow duplicate emails' do
      create(:user, email: 'duplicate@example.com')
      duplicate_user = build(:user, email: 'duplicate@example.com')
      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:email]).to include('has already been taken')
    end
  end
end
