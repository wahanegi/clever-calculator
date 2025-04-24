require 'rails_helper'

RSpec.describe "Api::V1::Settings", type: :request do
  describe "GET /api/v1/setting" do
    it "returns http success" do
      get api_v1_setting_path
      expect(response).to have_http_status(:success)
    end

    it "returns the current setting" do
      setting = Setting.current
      get api_v1_setting_path
      expect(response.parsed_body["data"]["attributes"]["style"]).to eq(setting.style)
    end
  end
end
