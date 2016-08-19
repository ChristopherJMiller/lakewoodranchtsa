require 'rails_helper'

RSpec.describe AnnouncementsController, type: :controller do

  let(:user) do
    FactoryGirl.create(:user, email: 'normaluser@test.com')
  end

  let(:user_admin) do
    FactoryGirl.create(:user, rank: 2, email: 'admin@test.com')
  end

  let(:announcement) do
    FactoryGirl.create(:announcement)
  end

  let(:valid_parameters) do
    {title: 'Test Announcement', body: 'Test body', user_id: user_admin.id}
  end

  let(:invalid_parameters) do
    {title: 'Test Announcement', body: nil, user_id: user_admin.id}
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
    it 'assigns all announcements as @announcements' do
      announcement = FactoryGirl.create(:announcement)
      get :index
      expect(assigns(:announcements)).to eq([announcement])
    end
  end

  describe 'GET #show' do
    context 'with a valid announcement' do
      before(:each) do
        get :show, {id: announcement.id}
      end

      it 'returns HTTP status 200 (OK)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns the requested announcement as @announcement' do
        expect(assigns(:announcement)).to eq(announcement)
      end
    end

    context 'with an invalid announcement' do
      it 'returns HTTP status 404 (Not Found)' do
        expect {
          get :show, {id: -1}
        }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe 'GET #new' do
    it 'assigns a new announcement as @announcement' do
      get :new
      expect(assigns(:announcement)).to be_a_new(Announcement)
    end
  end

  describe 'GET #edit' do
    context 'with a valid announcement' do
      before(:each) do
        get :edit, {id: announcement.id}
      end

      it 'returns HTTP status 200 (OK)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns the requested announcement as @announcement' do
        expect(assigns(:announcement)).to eq(announcement)
      end
    end

    context 'with an invalid event' do
      it 'returns HTTP status 404 (Not Found)' do
        expect {
          get :edit, {id: -1}
        }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe 'body #create' do
    context 'while logged in' do
      context 'as an admin' do
        context 'with valid parameters' do
          it 'returns HTTP status 201 (Created)' do
            post :create, {announcement: valid_parameters}, valid_session_admin
            expect(response).to have_http_status(:created)
          end

          it 'creates a new announcement' do
            expect {
              post :create, {announcement: valid_parameters}, valid_session_admin
            }.to change(Announcement, :count).by(1)
          end
        end

        context 'with invalid parameters' do
          it 'returns HTTP status 400 (Bad Request)' do
            post :create, {announcement: invalid_parameters}, valid_session_admin
            expect(response).to have_http_status(:bad_request)
          end
        end
      end

      context 'as not an admin' do
        it 'returns HTTP status 403 (Forbidden)' do
          post :create, {announcement: valid_parameters}, valid_session
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'while logged out' do
      it 'returns HTTP status 403 (Forbidden)' do
        post :create, {announcement: valid_parameters}
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PUT #update' do
    context 'with a valid announcement' do
      context 'as an admin' do
        context 'with valid parameters' do
          before(:each) do
            put :update, {id: announcement.id, announcement: valid_parameters}, valid_session_admin
          end

          it 'returns HTTP status 200 (OK)' do
            expect(response).to have_http_status(:ok)
          end

          it 'updates the requested announcement' do
            announcement.reload
            expect(announcement.title).to eq(valid_parameters[:title])
            expect(announcement.body).to eq(valid_parameters[:body])
          end
        end

        context 'with invalid parameters' do
          it 'returns HTTP status 400 (Bad Request)' do
            put :update, {id: announcement.id, announcement: invalid_parameters}, valid_session_admin
            expect(response).to have_http_status(:bad_request)
          end
        end
      end

      context 'not as an admin' do
        it 'returns HTTP status 403 (Forbidden)' do
          put :update, {id: announcement.id, announcement: valid_parameters}, valid_session
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'with an invalid announcement' do
      it 'returns HTTP status 404 (Not Found)' do
        put :update, {id: -1, announcement: valid_parameters}, valid_session_admin
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with a valid announcement' do
      context 'as an admin' do
        it 'returns HTTP status 200 (OK)' do
          delete :destroy, {id: announcement.id}, valid_session_admin
          expect(response).to have_http_status(:ok)
        end

        it 'deletes the requested announcement' do
          announcement_to_delete = FactoryGirl.create(:announcement)
          expect {
            delete :destroy, {id: announcement_to_delete.id}, valid_session_admin
          }.to change(Announcement, :count).by(-1)
        end
      end

      context 'not as an admin' do
        it 'returns HTTP status 403 (Forbidden)' do
          put :destroy, {id: announcement.id}, valid_session
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'with an invalid announcement' do
      it 'returns HTTP status 404 (Not Found)' do
        delete :destroy, {id: 1}
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
