require 'rails_helper'

RSpec.describe Note, type: :model do
  let!(:note) { create :note }

  context 'factory' do
    it 'is expected to have a valid factory' do
      expect(note).to be_valid
    end
  end

  context 'validations' do
    it 'is invalid without a quote' do
      note.quote = nil
      expect(note).to be_invalid
      expect(note.errors[:quote]).to include("can't be blank")
    end

    it 'is invalid without notes' do
      note.notes = nil
      expect(note).to be_invalid
      expect(note.errors[:notes]).to include("can't be blank")
    end
  end

  context 'associations' do
    it { is_expected.to belong_to(:quote).required }
    it { is_expected.to belong_to(:quote_item).optional }
  end

  context 'optional associations' do
    it 'can be valid without a quote_item' do
      note.quote_item = nil
      expect(note).to be_valid
    end
  end

  context 'is_printable column' do
    it 'defaults to false' do
      expect(note.is_printable).to be(false)
    end

    it 'can be set to true' do
      note = build(:note, is_printable: true)
      expect(note.is_printable).to be(true)
    end

    it 'can be set to false' do
      note = build(:note, is_printable: false)
      expect(note.is_printable).to be(false)
    end
  end
end
