require 'rails_helper'

RSpec.describe Setting, type: :model do
  subject(:setting) { build(:setting) }

  describe 'validations' do
    context 'when there is no existing setting' do
      it 'is valid' do
        expect(setting).to be_valid
      end
    end

    context 'when a setting already exists' do
      before { create(:setting) }

      it 'is invalid' do
        expect(setting).not_to be_valid
        expect(setting.errors[:base]).to include('Only one setting instance is allowed.')
      end
    end
  end

  describe 'attachments' do
    it { is_expected.to have_one_attached(:logo) }
  end
end
