require 'rails_helper'

RSpec.describe AccountabilitylogsController, type: :controller do
  let(:valid_parameters) do
    {dueby: '2016-08-24', closingdate: '2016-08-24'}
  end

  let(:invalid_parameters) do
    {dueby: nil, closingdate: '2016-08-24'}
  end

  let(:accountabilitylog) do
    FactoryGirl.create(:accountabilitylog)
  end

  let(:user) do
    FactoryGirl.create(:user)
  end

  let(:user_member) do
    FactoryGirl.create(:user, rank: 1)
  end

  let(:user_admin) do
    FactoryGirl.create(:user, rank: 2, email: 'admin@test.com')
  end

  let(:invalid_session) do
    {user_id: -1}
  end

  let(:valid_session) do
    {user_id: user.id}
  end

  let(:valid_session_admin) do
    {user_id: user_admin.id}
  end

  describe 'GET #index' do
    it 'assigns all accountability logs as @accountabilitylogs' do
      accountabilitylog = FactoryGirl.create(:accountabilitylog)
      get :index
      expect(assigns(:accountabilitylogs)).to eq([accountabilitylog])
    end
  end

  describe 'GET #show' do
    context 'with a valid accountability log' do
      before(:each) do
        get :show, {id: accountabilitylog.id}
      end

      it 'returns HTTP status 200 (OK)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns the requested accountability log as @accountabilitylog' do
        expect(assigns(:accountabilitylog)).to eq(accountabilitylog)
      end
    end

    context 'with an invalid accountabilitylog' do
      it 'returns HTTP status 404 (Not Found)' do
        expect {
          get :show, {id: -1}
        }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe 'GET #new' do
    it 'assigns a new accountabilitylog as @accountabilitylog' do
      get :new
      expect(assigns(:accountabilitylog)).to be_a_new(Accountabilitylog)
    end
  end

  describe 'GET #edit' do
    context 'with a valid accountability log' do
      before(:each) do
        get :edit, {id: accountabilitylog.id}
      end

      it 'returns HTTP status 200 (OK)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns the requested event as @accountabilitylog' do
        expect(assigns(:accountabilitylog)).to eq(accountabilitylog)
      end
    end

    context 'with an invalid accountabilitylog' do
      it 'returns HTTP status 404 (Not Found)' do
        expect {
          get :edit, {id: -1}
        }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe 'POST #create' do
    context 'while logged in' do
      context 'as an admin' do
        context 'with valid parameters' do
          it 'returns HTTP status 201 (Created)' do
            post :create, {accountabilitylog: valid_parameters}, valid_session_admin
            expect(response).to have_http_status(:created)
          end

          it 'creates a new accountabilitylog' do
            expect {
              post :create, {accountabilitylog: valid_parameters}, valid_session_admin
            }.to change(Accountabilitylog, :count).by(1)
          end
        end

        context 'with invalid parameters' do
          it 'returns HTTP status 400 (Bad Request)' do
            post :create, {accountabilitylog: invalid_parameters}, valid_session_admin
            expect(response).to have_http_status(:bad_request)
          end
        end
      end

      context 'as not an admin' do
        it 'returns HTTP status 403 (Forbidden)' do
          post :create, {accountabilitylog: valid_parameters}, valid_session
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'while logged out' do
      it 'returns HTTP status 403 (Forbidden)' do
        post :create, {accountabilitylog: valid_parameters}
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PUT #update' do
    context 'with a valid event' do
      context 'as an admin' do
        context 'with valid parameters' do
          before(:each) do
            put :update, {id: accountabilitylog.id, accountabilitylog: valid_parameters}, valid_session_admin
          end

          it 'returns HTTP status 200 (OK)' do
            expect(response).to have_http_status(:ok)
          end

          it 'updates the requested accountability log' do
            accountabilitylog.reload
            expect(accountabilitylog.dueby.to_s(:db)).to eq(valid_parameters[:dueby])
            expect(accountabilitylog.closingdate.to_s(:db)).to eq(valid_parameters[:closingdate])
          end
        end

        context 'with invalid parameters' do
          it 'returns HTTP status 400 (Bad Request)' do
            put :update, {id: accountabilitylog.id, accountabilitylog: invalid_parameters}, valid_session_admin
            expect(response).to have_http_status(:bad_request)
          end
        end
      end

      context 'not as an admin' do
        it 'returns HTTP status 403 (Forbidden)' do
          put :update, {id: accountabilitylog.id, accountabilitylog: valid_parameters}, valid_session
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'with an invalid accountability log' do
      it 'returns HTTP status 404 (Not Found)' do
        put :update, {id: -1, accountabilitylog: valid_parameters}, valid_session_admin
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with a valid accountability log' do
      context 'as an admin' do

        it 'returns HTTP status 200 (OK)' do
          delete :destroy, {id: accountabilitylog.id}, valid_session_admin
          expect(response).to have_http_status(:ok)
        end

        it 'deletes the requested event' do
          accountabilitylog_to_remove = FactoryGirl.create(:accountabilitylog)
          expect {
            delete :destroy, {id: accountabilitylog_to_remove.id}, valid_session_admin
          }.to change { Accountabilitylog.count }.by(-1)
        end
      end

      context 'not as an admin' do
        it 'returns HTTP status 403 (Forbidden)' do
          put :destroy, {id: accountabilitylog.id}, valid_session
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'with an invalid event' do
      it 'returns HTTP status 404 (Not Found)' do
        delete :destroy, {id: 1}
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
