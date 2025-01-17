require 'rails_helper'

RSpec.describe Customer, type: :model do
  context 'validations' do
    it { should validate_presence_of(:company_name) }
    it { should validate_uniqueness_of(:company_name) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:position) }
    it { should validate_presence_of(:address) }
  end
end
