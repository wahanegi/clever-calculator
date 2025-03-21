require 'rails_helper'

RSpec.describe Category, type: :model do
  context 'validations' do
    subject { build(:category) }

    it { is_expected.to be_valid }

    describe 'name' do
      let(:printable_ascii_characters) { (33..126).map(&:chr).join }
      let(:printable_utf_8_characters) { (126..255).map { |c| c.chr(Encoding::UTF_8) }.join }

      it { is_expected.to validate_presence_of(:name) }

      it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:is_disabled).with_message("A category with this name already exists") }

      it 'does not allow duplicate names for active categories' do
        category = create(:category, name: 'Category', is_disabled: false)
        duplicate_category = build(:category, name: category.name, is_disabled: false)

        expect(duplicate_category).not_to be_valid
        expect(duplicate_category.errors[:name]).to include("A category with this name already exists")
      end

      it 'allows duplicate names for disabled categories' do
        category = create(:category, is_disabled: true)

        2.times do
          duplicate_category = build(:category, is_disabled: true, name: category.name)

          expect(duplicate_category).to be_valid
          expect(duplicate_category.errors[:name]).to be_empty
          expect(duplicate_category.save).to be_truthy
        end
      end

      it { is_expected.to allow_value(printable_ascii_characters).for(:name) }
      it { is_expected.not_to allow_value(printable_utf_8_characters).for(:name).with_message('must contain only ASCII characters') }

      ['Category with  more  than one space  between words     123',
       '   Category with starting spaces',
       'Category with ending spaces   '].each do |category_name_with_spaces|
        it { is_expected.not_to allow_value(category_name_with_spaces).for(:name).with_message('must contain only single spaces between words') }
      end
    end

    describe 'is_disabled' do
      it { is_expected.to have_attributes(is_disabled: false) }
    end
  end
end
