require 'rails_helper'

RSpec.describe Api::V1::SettingsHelper, type: :helper do
  let(:expected_setting) { Setting.current }

  it "should return the current setting" do
    expect(helper.current_setting).to eq(expected_setting)
  end
end
