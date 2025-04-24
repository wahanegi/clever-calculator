require 'rails_helper'

RSpec.describe "Api::V1::Settings", type: :request do
  describe "GET /api/v1/setting" do
    let(:current_setting) { Setting.current }
    let(:expected_current_setting_hash) do
      {
        "data" => {
          "attributes" => { "logo" => current_setting.logo.url },
          "id" => current_setting.id.to_s,
          "type" => "setting"
        }
      }
    end

    it "returns http success" do
      get api_v1_setting_path

      expect(response).to have_http_status(:success)
      expect(response.parsed_body).to eq(expected_current_setting_hash)
    end
  end
end
