require 'rails_helper'

RSpec.describe Setting, type: :model do
  subject(:setting) { build(:setting) }

  describe 'validations' do
    context 'when there is no existing setting' do
      it 'is valid' do
        expect(setting).to be_valid
      end
    end

    context 'when setting already exists' do
      before { create(:setting) }

      it 'is not valid' do
        expect(setting).not_to be_valid
        expect(setting.errors[:base]).to include('Only one instance of Setting is allowed.')
      end
    end

    context 'when an image is larger than 1MB' do
      let(:three_mb_image) { file_fixture('3_megabytes_logo.png') }

      it 'is invalid for logo_light_background' do
        setting.logo_light_background.attach(three_mb_image)
        expect(setting).not_to be_valid
        expect(setting.errors.messages_for(:logo_light_background)).to include('must be less than 1MB')
      end

      it 'is invalid for logo_dark_background' do
        setting.logo_dark_background.attach(three_mb_image)
        expect(setting).not_to be_valid
        expect(setting.errors.messages_for(:logo_dark_background)).to include('must be less than 1MB')
      end

      it 'is invalid for word_header_document_logo' do
        setting.word_header_document_logo.attach(three_mb_image)
        expect(setting).not_to be_valid
        expect(setting.errors.messages_for(:word_header_document_logo)).to include('must be less than 1MB')
      end
    end

    context 'when the image type is not allowed' do
      let(:invalid_file) { file_fixture('invalid_file.csv') }

      it 'is invalid for logo_light_background' do
        setting.logo_light_background.attach(invalid_file)
        expect(setting).not_to be_valid
        expect(setting.errors.messages_for(:logo_light_background)).to include('must be a JPEG or PNG file')
      end

      it 'is invalid for logo_dark_background' do
        setting.logo_dark_background.attach(invalid_file)
        expect(setting).not_to be_valid
        expect(setting.errors.messages_for(:logo_dark_background)).to include('must be a JPEG or PNG file')
      end

      it 'is invalid for word_header_document_logo' do
        setting.word_header_document_logo.attach(invalid_file)
        expect(setting).not_to be_valid
        expect(setting.errors.messages_for(:word_header_document_logo)).to include('must be a JPEG or PNG file')
      end
    end
  end

  describe 'attachments' do
    it { is_expected.to have_one_attached(:logo_light_background) }
    it { is_expected.to have_one_attached(:logo_dark_background) }
    it { is_expected.to have_one_attached(:word_header_document_logo) }
  end
end
