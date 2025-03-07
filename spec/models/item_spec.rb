require 'rails_helper'

RSpec.descibe Item, type: :model do
    subject { create(:item) }
    let(:item) { Item.new }

    context 'factory' do
        it 'is expect to have valid factory' do
          expect(subject).to be_valid
        end
    end

    context 'assosiations' do
        it { is_expected.to belong_to(:category).optional }
    end
    
    context 'validation' do 
        it { is_expected.to validate_presence_of(:name) }
        it { is_expected.to validate_uniqueness_of(:name).scoped_to(:category_id) } 
        it { is_expected.to validate_presence_of(:pricing_type) }
    end

    context 'enum' do
        it { is_expected.to define_enum_for(:pricing_type).with_values(fixed: 0, open: 1, fixed_open: 2) }
    end

    context 'default values' do 
        it 'sets default pricing_type to "fixed' do
            expect(item.pricing_type).to eq('fixed')
        end

        it 'sets default is_disabled to false' do
            expect(item.is_disabled).to eq(false)
        end
    end

    context 'negative validations' do
        it 'is not valid without a name' do
          invalid_item = build(:item, name: nil)
          expect(invalid_item).not_to be_valid
          expect(invalid_item.errors[:name]).to include("can't be blank")
        end
    
        it 'is not valid without pricing_type' do
          invalid_item = build(:item, pricing_type: nil)
          expect(invalid_item).not_to be_valid
          expect(invalid_item.errors[:pricing_type]).to include("can't be blank")
        end
    
        it 'is not valid with duplicate name within the same category' do
          category = create(:category)
          create(:item, name: 'Duplicate', category: category)
          duplicate_item = build(:item, name: 'Duplicate', category: category)
          expect(duplicate_item).not_to be_valid
          expect(duplicate_item.errors[:name]).to include("Item name must be unique within category")
        end
      end
end