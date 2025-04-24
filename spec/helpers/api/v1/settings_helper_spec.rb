require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the Api::V1::SettingsHelper. For example:
#
# describe Api::V1::SettingsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe Api::V1::SettingsHelper, type: :helper do
  let(:setting) { Setting.current }

  it "should return the current setting" do
    expect(helper.current_setting).to eq(setting)
  end
end
