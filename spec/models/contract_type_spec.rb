require 'rails_helper'

RSpec.describe ContractType, type: :model do
  subject { create(:contract_type) }
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end
end
