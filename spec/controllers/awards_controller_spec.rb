require 'rails_helper'

RSpec.describe AwardsController, type: :controller do

  let(:award) do
    FactoryGirl.create(:award)
  end

  let(:user) do
    FactoryGirl.create(:user)
  end

  let(:user_member) do
    FactoryGirl.create(:user, email: 'member@test.com', rank: 1)
  end

  let(:user_admin) do
    FactoryGirl.create(:user, rank: 2, email: 'admin@test.com')
  end

  let(:valid_parameters_create) do
    {name: 'Test Award'}
  end

  let(:valid_parameters) do
    {name: 'Test Award', value: 5, verified: true, user_id: user_member.id}
  end

  let(:invalid_parameters) do
    {name: nil, value: 5, verified: true, user_id: user_member.id}
  end

  let(:invalid_session) do
    {user_id: -1}
  end

  let(:valid_session) do
    {user_id: user.id}
  end

  let(:valid_session_member) do
    {user_id: user_member.id}
  end

  let(:valid_session_admin) do
    {user_id: user_admin.id}
  end

  describe 'GET #index' do
    it 'assigns all awards as @awards' do
      award = FactoryGirl.create(:award)
      get :index, user_id: user_member.id
      expect(assigns(:awards)).to eq([award])
    end
  end

  describe 'GET #show' do
    context 'with a valid award' do
      before(:each) do
        get :show, {user_id: award.user.id, id: award.id}
      end

      it 'returns HTTP status 200 (OK)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns the requested accountability log as @award' do
        expect(assigns(:award)).to eq(award)
      end
    end

    context 'with an invalid award' do
      it 'returns HTTP status 404 (Not Found)' do
        expect {
          get :show, {user_id: award.user.id, id: -1}
        }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe 'GET #new' do
    it 'assigns a new award as @award' do
      get :new, user_id: award.user.id
      expect(assigns(:award)).to be_a_new(Award)
    end
  end

  describe 'GET #edit' do
    context 'with a valid award log' do
      before(:each) do
        get :edit, {user_id: award.user.id, id: award.id}
      end

      it 'returns HTTP status 200 (OK)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns the requested award as @award' do
        expect(assigns(:award)).to eq(award)
      end
    end

    context 'with an invalid award' do
      it 'returns HTTP status 404 (Not Found)' do
        expect {
          get :edit, {user_id: award.user.id, id: -1}
        }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe 'POST #create' do
    context 'while logged in' do
      context 'as a member' do
        context 'with valid parameters' do
          it 'returns HTTP status 201 (Created)' do
            post :create, {user_id: award.user.id, award: valid_parameters_create}, valid_session_member
            expect(response).to have_http_status(:created)
          end

          it 'creates a new award' do
            expect {
              post :create, {user_id: user_member.id, award: valid_parameters_create}, valid_session_member
            }.to change(Award, :count).by(1)
          end
        end

        context 'with invalid parameters' do
          it 'returns HTTP status 400 (Bad Request)' do
            post :create, {user_id: award.user.id, award: invalid_parameters}, valid_session_member
            expect(response).to have_http_status(:bad_request)
          end
        end
      end

      context 'while not a member or higher' do
        it 'returns HTTP status 403 (Forbidden)' do
          post :create, {user_id: user.id, award: valid_parameters_create}, valid_session
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'while logged out' do
      it 'returns HTTP status 403 (Forbidden)' do
        post :create, {user_id: award.user.id, award: valid_parameters_create}
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PUT #update' do
    context 'with a valid award' do
      context 'as an admin' do
        context 'with valid parameters' do
          before(:each) do
            put :update, {user_id: award.user.id, id: award.id, award: valid_parameters}, valid_session_admin
          end

          it 'returns HTTP status 200 (OK)' do
            expect(response).to have_http_status(:ok)
          end

          it 'updates the requested accountability log' do
            award.reload
            expect(award.name).to eq(valid_parameters[:name])
            expect(award.value).to eq(valid_parameters[:value])
            expect(award.verified).to eq(valid_parameters[:verified])
          end
        end

        context 'with invalid parameters' do
          it 'returns HTTP status 400 (Bad Request)' do
            put :update, {user_id: award.user.id, id: award.id, award: invalid_parameters}, valid_session_admin
            expect(response).to have_http_status(:bad_request)
          end
        end
      end

      context 'not as an admin' do
        it 'returns HTTP status 403 (Forbidden)' do
          put :update, {user_id: user_member.id, id: award.id, award: valid_parameters}, valid_session_member
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'with an invalid award' do
      it 'returns HTTP status 404 (Not Found)' do
        put :update, {user_id: award.user.id, id: -1, award: valid_parameters}, valid_session_admin
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with a valid award' do
      context 'as an admin' do

        it 'returns HTTP status 200 (OK)' do
          delete :destroy, {user_id: award.user.id, id: award.id}, valid_session_admin
          expect(response).to have_http_status(:ok)
        end

        it 'deletes the requested event' do
          award_to_remove = FactoryGirl.create(:award)
          expect {
            delete :destroy, {user_id: award_to_remove.user.id, id: award_to_remove.id}, valid_session_admin
          }.to change { Award.count }.by(-1)
        end
      end

      context 'not as an admin' do
        it 'returns HTTP status 403 (Forbidden)' do
          put :destroy, {user_id: user_member.id, id: award.id}, valid_session_member
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'with an invalid award' do
      it 'returns HTTP status 404 (Not Found)' do
        delete :destroy, {user_id: user_member.id, id: 1}, valid_session_member
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
