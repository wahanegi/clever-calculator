require 'rails_helper'

RSpec.describe "Admin::SettingController", type: :request do
  let!(:setting) { create(:setting) }
  let(:current_setting) { Setting.current }
  let(:logo_light_background) { fixture_file_upload(Rails.root.join("spec/fixtures/files/logo.png"), "image/png") }
  let(:logo_dark_background) { fixture_file_upload(Rails.root.join("spec/fixtures/files/logo.png"), "image/png") }
  let(:word_header_document_logo) { fixture_file_upload(Rails.root.join("spec/fixtures/files/logo.png"), "image/png") }
  let(:sample_style) { BrandColorBuilder.new('#FFFFFF', '#FFFFFF', '#FFFFFF', '#FFFFFF', '#FFFFFF').build_css }
  let(:default_colors) { BrandColorParser.default_colors }
  let(:default_style) { BrandColorBuilder.new(default_colors[0], default_colors[1], default_colors[2], default_colors[3], default_colors[4]).build_css }

  before do
    sign_in create(:admin_user), scope: :admin_user
  end

  after do
    sign_out :admin_user
  end

  describe "GET /admin/setting" do
    it "returns http success" do
      get admin_setting_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "PUT /admin/setting/update" do
    it "updates the current setting" do
      put admin_setting_update_path, params: {
        setting: {
          logo_light_background: logo_light_background,
          logo_dark_background: logo_dark_background,
          word_header_document_logo: word_header_document_logo,
          primary_color: '#FFFFFF',
          secondary_color: '#FFFFFF',
          blue_light_color: '#FFFFFF',
          blue_sky_color: '#FFFFFF',
          light_color: '#FFFFFF'
        }
      }

      expect(response).to redirect_to(admin_setting_path)

      follow_redirect!

      expect(response.body).to include('Setting was successfully updated')
      expect(current_setting.logo_light_background).to be_attached
      expect(current_setting.logo_dark_background).to be_attached
      expect(current_setting.word_header_document_logo).to be_attached
      expect(current_setting.style).to be_eql sample_style

      get root_path

      follow_redirect!

      expect(response.body).to include(sample_style)
    end
  end

  describe "PATCH /admin/setting/reset" do
    it "resets the current setting" do
      current_setting.update(logo_light_background: logo_light_background,
                             logo_dark_background: logo_dark_background,
                             word_header_document_logo: word_header_document_logo,
                             style: sample_style)

      patch admin_setting_reset_path

      expect(response).to redirect_to(admin_setting_path)

      follow_redirect!

      current_setting.reload

      expect(response.body).to include('Settings reset successfully.')
      expect(current_setting.logo_light_background).not_to be_attached
      expect(current_setting.logo_dark_background).not_to be_attached
      expect(current_setting.word_header_document_logo).not_to be_attached
      expect(current_setting.reload.style).to be_eql default_style
    end
  end

  describe "DELETE /admin/setting/remove_image" do
    it 'removes each image from the setting' do
      current_setting.update(logo_light_background: logo_light_background,
                             logo_dark_background: logo_dark_background,
                             word_header_document_logo: word_header_document_logo)

      %w[logo_light_background logo_dark_background word_header_document_logo].each do |attribute|
        delete admin_setting_remove_image_path(type: attribute)

        expect(response).to redirect_to(admin_setting_path)

        follow_redirect!

        expect(response.body).to include("#{attribute.humanize} was successfully removed.")
      end

      current_setting.reload

      expect(current_setting.logo_light_background).not_to be_attached
      expect(current_setting.logo_dark_background).not_to be_attached
      expect(current_setting.word_header_document_logo).not_to be_attached
    end

    it 'returns an error if the image type does not exist' do
      delete admin_setting_remove_image_path(type: 'invalid_type')

      expect(response).to redirect_to(admin_setting_path)
      follow_redirect!
      expect(response.body).to include('Unknown or missing image type')
    end
  end
end
