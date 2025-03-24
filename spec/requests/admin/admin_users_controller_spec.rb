require 'rails_helper'

RSpec.describe "Admin::AdminUsersController", type: :request do
  let!(:admin_user) { create(:admin_user) }

  let(:admin_user_params) do
    { email: 'admin.123@example.com',
      name: 'test',
      password: 'password@123' }
  end

  before do
    sign_in admin_user, scope: :admin_user
  end

  describe "routes" do
    context 'GET /admin/admin_users/new' do
      it "should get new" do
        get new_admin_admin_user_path

        expect(response).to have_http_status(:ok)
      end
    end

    context 'POST /admin/admin_users' do
      let(:last_admin_user) { AdminUser.last }

      it 'creates the model successfully and redirects to index' do
        post admin_admin_users_path, params: { admin_user: admin_user_params }

        expect(response).to redirect_to(admin_admin_users_path)

        follow_redirect!

        expect(response.body).to include('Admin user was successfully created.')
        expect(last_admin_user.email).to be_eql admin_user_params[:email]
      end
    end

    context 'GET /admin/admin_users/:id/edit' do
      it "should get edit" do
        get edit_admin_admin_user_path(admin_user)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'PATCH /admin/admin_users/:id' do
      it 'updates the email successfully and redirects to show' do
        patch admin_admin_user_path(admin_user), params: { admin_user: { email: '123@example.com' } }

        expect(response).to redirect_to(admin_admin_user_path(admin_user))

        follow_redirect!

        expect(response.body).to include('Admin user was successfully updated.')
        expect(admin_user.reload.email).to be_eql '123@example.com'
      end
    end
  end
end
