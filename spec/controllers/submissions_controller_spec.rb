require 'rails_helper'

RSpec.describe SubmissionsController, type: :controller do
  let(:user) do
    FactoryGirl.create(:user)
  end

  let(:user_member) do
    FactoryGirl.create(:user, rank: 1, email: 'member@test.com')
  end

  let(:user_admin) do
    FactoryGirl.create(:user, rank: 2, email: 'admin@test.com')
  end

  let(:different_user) do
    FactoryGirl.create(:user, rank: 1, email: 'test2@test.com')
  end

  let(:accountability_log) do
    FactoryGirl.create(:accountability_log)
  end

  let(:submission) do
    FactoryGirl.create(:submission)
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

  let(:valid_session_owning_user) do
    {user_id: submission.user.id}
  end

  let(:valid_parameters) do
    {binderstatus: 'Binder', tasks: 'Tasks', goals: 'Goals'}
  end

  let(:invalid_parameters) do
    {binderstatus: nil, tasks: 'Tasks', goals: 'Goals'}
  end

  describe 'GET #index' do
    context 'as an admin' do
      it 'assigns all submissions of a acconutability log to @submissions' do
        get :index, {accountability_log_id: submission.accountability_log.id}, valid_session_admin
        expect(assigns(:submissions)).to eq([submission])
      end
    end

    context 'not as an admin' do
      it 'returns HTTP status 403 (Forbiden)' do
        get :index, accountability_log_id: accountability_log.id
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET #new' do
    it 'assigns a new submission as @submission' do
      get :new, accountability_log_id: accountability_log.id
      expect(assigns(:submission)).to be_a_new(Submission)
    end
  end

  describe 'GET #show' do
    context 'with valid parameters' do
      context 'as a site admin' do
        before do
          get :show, {accountability_log_id: submission.accountability_log.id, id: submission.id}, valid_session_admin
        end

        it 'returns HTTP status 200 (OK)' do
          expect(response).to have_http_status(:ok)
        end

        it 'assigns the requested submission as @submission' do
          expect(assigns(:submission)).to eq(submission)
        end
      end

      context 'as the requested user' do
        before do
          get :show, {accountability_log_id: submission.accountability_log.id, id: submission.id}, user_id: submission.user.id
        end

        it 'returns HTTP status 200 (OK)' do
          expect(response).to have_http_status(:ok)
        end

        it 'assigns the requested submission as @submission' do
          expect(assigns(:submission)).to eq(submission)
        end
      end

      context 'as a normal user' do
        before do
          get :show, {accountability_log_id: submission.accountability_log.id, id: submission.id}, user_id: different_user.id
        end

        it 'returns HTTP status 403 (Forbidden)' do
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'when logged out' do
        before do
          get :show, accountability_log_id: submission.accountability_log.id, id: submission.id
        end

        it 'returns HTTP status 403 (Forbidden)' do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'with invalid parameters' do
      it 'returns HTTP status 404 (Not Found)' do
        expect do
          get :show, accountability_log_id: submission.accountability_log.id, id: -1
        end.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      context 'as a logged in user' do
        context 'when the user is a site member' do
          it 'returns HTTP status 201 (Created)' do
            post :create, {accountability_log_id: accountability_log.id, submission: valid_parameters}, valid_session_member
            expect(response).to have_http_status(:created)
          end

          it 'creates a new submission' do
            expect do
              post :create, {accountability_log_id: accountability_log.id, submission: valid_parameters}, valid_session_member
            end.to change(Submission, :count).by(1)
          end
        end

        context 'while the user already submitted to the accountability log' do
          it 'returns HTTP status 409 (Conflict)' do
            post :create, {accountability_log_id: accountability_log.id, submission: valid_parameters}, valid_session_member
            post :create, {accountability_log_id: accountability_log.id, submission: valid_parameters}, valid_session_member
            expect(response).to have_http_status(:conflict)
          end
        end

        context 'when the user is not a site member' do
          it 'returns a HTTP status 403 (Forbidden)' do
            post :create, {accountability_log_id: accountability_log.id, submission: valid_parameters}, valid_session
            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      context 'as a logged out user' do
        it 'returns HTTP status 403 (Forbidden)' do
          post :create, accountability_log_id: accountability_log.id, submission: valid_parameters
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'with invalid parameters' do
      it 'returns HTTP status 403 (Forbidden)' do
        post :create, {accountability_log_id: accountability_log.id, submission: invalid_parameters}, valid_session_member
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with a valid accountability log' do
      context 'as an admin' do
        it 'returns HTTP status 200 (OK)' do
          delete :destroy, {accountability_log_id: submission.accountability_log.id, id: submission.id}, valid_session_admin
          expect(response).to have_http_status(:ok)
        end

        it 'deletes the requested submission' do
          submission_to_delete = FactoryGirl.create(:submission, user_id: user_member.id)
          expect do
            delete :destroy, {accountability_log_id: submission_to_delete.accountability_log.id, id: submission_to_delete.id}, valid_session_admin
          end.to change(Submission, :count).by(-1)
        end
      end

      context 'not as an admin' do
        context 'as the requested user' do
          it 'returns HTTP status 200 (OK)' do
            delete :destroy, {accountability_log_id: submission.accountability_log.id, id: submission.id}, valid_session_owning_user
            expect(response).to have_http_status(:ok)
          end

          it 'deletes the requested submission' do
            submission_to_delete = FactoryGirl.create(:submission, user_id: user_member.id)
            expect do
              delete :destroy, {accountability_log_id: submission_to_delete.accountability_log.id, id: submission_to_delete.id}, user_id: user_member.id
            end.to change(Submission, :count).by(-1)
          end
        end

        context 'not as the requested user' do
          it 'returns HTTP status 403 (Forbidden)' do
            submission_to_delete = FactoryGirl.create(:submission, user_id: user_member.id)
            delete :destroy, {accountability_log_id: submission_to_delete.accountability_log.id, id: submission_to_delete.id}, user_id: different_user.id
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    context 'with an invalid user' do
      it 'returns HTTP status 404 (Not Found)' do
        delete :destroy, {accountability_log_id: submission.accountability_log.id, id: -1}, valid_session_owning_user
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
