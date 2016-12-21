require 'rails_helper'
# Tests for the Admin Controller
RSpec.describe AdminController, type: :controller do
  let(:admin) do
    FactoryGirl.create(:user, rank: 6)
  end

  let(:user) do
    FactoryGirl.create(:user, email: 'user@test.com')
  end

  let(:valid_session_admin) do
    {user_id: admin.id}
  end

  let(:valid_session) do
    {user_id: user.id}
  end

  describe 'GET #dashboard' do
    context 'as an admin' do
      it 'will return a 200 OK' do
        get :dashboard, nil, valid_session_admin
        expect(response).to have_http_status(200)
      end
    end

    context 'as not an admin' do
      it 'will return 403 Forbidden' do
        get :dashboard, nil, valid_session
        expect(response).to have_http_status(403)
      end
    end

    context 'while logged out' do
      it 'will return 403 Forbidden' do
        get :dashboard
        expect(response).to have_http_status(403)
      end
    end
  end
end
