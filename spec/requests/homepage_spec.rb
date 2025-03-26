require 'rails_helper'

RSpec.describe "Homepages", type: :request do
  let!(:user) { create :user }
  describe "GET /index" do
    before { sign_in user }
    it "returns http success" do
      get "/homepage/index"
      expect(response).to have_http_status(:success)
    end
  end
end
