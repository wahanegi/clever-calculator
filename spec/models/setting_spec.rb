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

      it 'is invalid for app_logo_icon' do
        setting.app_logo_icon.attach(three_mb_image)
        expect(setting).not_to be_valid
        expect(setting.errors.messages_for(:app_logo_icon)).to include('must be less than 1MB')
      end

      it 'is invalid for app_background_icon' do
        setting.app_background_icon.attach(three_mb_image)
        expect(setting).not_to be_valid
        expect(setting.errors.messages_for(:app_background_icon)).to include('must be less than 1MB')
      end

      it 'is invalid for word_header_document_logo' do
        setting.word_header_document_logo.attach(three_mb_image)
        expect(setting).not_to be_valid
        expect(setting.errors.messages_for(:word_header_document_logo)).to include('must be less than 1MB')
      end
    end

    context 'when the image type is not allowed' do
      let(:invalid_file) { file_fixture('invalid_file.csv') }

      it 'is invalid for app_logo_icon' do
        setting.app_logo_icon.attach(invalid_file)
        expect(setting).not_to be_valid
        expect(setting.errors.messages_for(:app_logo_icon)).to include('must be a JPEG, SVG or PNG file')
      end

      it 'is invalid for app_background_icon' do
        setting.app_background_icon.attach(invalid_file)
        expect(setting).not_to be_valid
        expect(setting.errors.messages_for(:app_background_icon)).to include('must be a JPEG, SVG or PNG file')
      end

      it 'is invalid for word_header_document_logo' do
        setting.word_header_document_logo.attach(invalid_file)
        expect(setting).not_to be_valid
        expect(setting.errors.messages_for(:word_header_document_logo)).to include('must be a JPEG, SVG or PNG file')
      end
    end
  end

  describe 'attachments' do
    it { is_expected.to have_one_attached(:app_logo_icon) }
    it { is_expected.to have_one_attached(:app_background_icon) }
    it { is_expected.to have_one_attached(:word_header_document_logo) }
  end
end
