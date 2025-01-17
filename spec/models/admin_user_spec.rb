require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  subject { build(:admin_user) }

  it 'is expect to have valid factory' do
    expect(subject).to be_valid
  end

  it_behaves_like 'validatable user'
end
