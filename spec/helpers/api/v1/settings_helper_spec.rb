require 'rails_helper'

RSpec.describe Api::V1::SettingsHelper, type: :helper do
  let(:setting) { Setting.current }

  it "should return the current setting" do
    expect(helper.current_setting).to eq(setting)
  end
end
