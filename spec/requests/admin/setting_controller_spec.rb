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

  describe "PUT /admin/setting/reset" do
    # let(:logo) { fixture_file_upload(Rails.root.join("spec/fixtures/files/logo.png"), "image/png") }
    # let(:default_colors) { BrandColorParser.default_colors }
    # let(:default_style) { BrandColorBuilder.new(default_colors[0], default_colors[1], default_colors[2], default_colors[3]).build_css }
    # let(:style) { BrandColorBuilder.new('#FFFFFF', '#FFFFFF', '#FFFFFF', '#FFFFFF').build_css }
    #
    # it "resets the current setting" do
    #   current_setting.update!(style: style) # set custom style
    #
    #   expect(current_setting.style).to include(style)
    #
    #   put admin_setting_reset_path
    #
    #   expect(response).to redirect_to(admin_setting_path)
    #
    #   follow_redirect!
    #
    #   expect(response.body).to include('Setting was successfully reset')
    #
    #   follow_redirect!
    #
    #   expect(current_setting.style).to be_eql default_style
    # end
  end

  describe "DELETE /admin/setting/remove_image" do
    let(:image) { fixture_file_upload(Rails.root.join("spec/fixtures/files/logo.png"), "image/png") }

    it 'removes image from setting' do
      delete admin_setting_remove_image_path(image: 'logo')

      expect(response).to redirect_to(admin_setting_path)

      follow_redirect!

      current_setting.reload

      expect(response.body).to include('Logo was successfully removed.')
      expect(current_setting.logo).not_to be_attached
    end
  end
end
