require 'rails_helper'

RSpec.describe Category, type: :model do
  context 'validations' do
    subject { build(:category) }

    it { is_expected.to be_valid }

    describe 'name' do
      it { is_expected.to validate_presence_of(:name) }

      it do
        is_expected.to validate_uniqueness_of(:name).case_insensitive
                                                    .scoped_to(:is_disabled)
                                                    .with_message("A category with this name already exists")
      end

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
    end

    describe 'is_disabled' do
      it { is_expected.to have_attributes(is_disabled: false) }
    end
  end
end
