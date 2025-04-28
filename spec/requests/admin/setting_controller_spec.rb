require 'rails_helper'

RSpec.describe "Admin::SettingController", type: :request do
  let!(:setting) { create(:setting) }
  let(:current_setting) { Setting.current }

  before do
    sign_in create(:admin_user), scope: :admin_user
  end

  after do
    sign_out :admin_user
  end

  describe "GET /admin/setting" do
    it "returns http success" do
      get admin_categories_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "PUT /admin/setting/update" do
    let(:logo) { fixture_file_upload(Rails.root.join("spec/fixtures/files/logo.png"), "image/png") }
    let(:style) { BrandColorBuilder.new('#FFFFFF', '#FFFFFF', '#FFFFFF', '#FFFFFF').build_css }

    it "updates the current setting" do
      put admin_setting_update_path, params: {
        setting: {
          logo: logo,
          primary_color: '#FFFFFF',
          secondary_color: '#FFFFFF',
          blue_light_color: '#FFFFFF',
          blue_sky_color: '#FFFFFF'
        }
      }

      expect(response).to redirect_to(admin_setting_path)

      follow_redirect!

      expect(response.body).to include('Setting was successfully updated')
      expect(current_setting.logo).to be_attached
      expect(current_setting.style).to be_eql style

      get root_path

      follow_redirect!

      expect(response.body).to include(style)
    end
  end
end
