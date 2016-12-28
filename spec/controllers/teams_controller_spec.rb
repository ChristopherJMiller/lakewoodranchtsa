require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  let(:event) do
    FactoryGirl.create(:event)
  end

  let(:team) do
    FactoryGirl.create(:team)
  end

  let(:team_member) do
    FactoryGirl.create(:team_member)
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

  let(:valid_session_member) do
    {user_id: user_member.id}
  end

  let(:valid_session_team_member) do
    {user_id: team_member.user.id}
  end

  let(:valid_session_admin) do
    {user_id: user_admin.id}
  end

  let(:valid_parameters) do
    {name: 'Test Team', event_id: event.id}
  end

  let(:invalid_parameters) do
    {name: nil, event_id: event.id}
  end

  describe 'GET #index' do
    it 'assigns all teams as @teams' do
      get :index, event_id: team.event.id
      expect(assigns(:teams)).to eq([team])
    end
  end

  describe 'GET #show' do
    context 'with a valid team' do
      before do
        get :show, event_id: team.event.id, id: team.id
      end

      it 'returns HTTP status 200 (OK)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns the requested team as @team' do
        expect(assigns(:team)).to eq(team)
      end
    end

    context 'with an invalid team' do
      it 'returns HTTP status 404 (Not Found)' do
        expect do
          get :show, event_id: team.event.id, id: -1
        end.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe 'GET #new' do
    it 'assigns a new team as @team' do
      get :new, event_id: team.event.id
      expect(assigns(:team)).to be_a_new(Team)
    end
  end

  describe 'GET #edit' do
    context 'with a valid team' do
      before do
        get :edit, event_id: team.event.id, id: team.id
      end

      it 'returns HTTP status 200 (OK)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns the requested team as @team' do
        expect(assigns(:team)).to eq(team)
      end
    end

    context 'with an invalid team' do
      it 'returns HTTP status 404 (Not Found)' do
        expect do
          get :edit, event_id: team.event.id, id: -1
        end.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe 'POST #create' do
    context 'while logged in' do
      context 'as a admin' do
        context 'with valid parameters' do
          it 'returns HTTP status 201 (Created)' do
            post :create, {event_id: event.id, team: valid_parameters}, valid_session_admin
            expect(response).to have_http_status(:created)
          end

          it 'creates a new team' do
            expect do
              post :create, {event_id: event.id, team: valid_parameters}, valid_session_admin
            end.to change(Team, :count).by(1)
          end
        end

        context 'with invalid parameters' do
          it 'returns HTTP status 400 (Bad Request)' do
            post :create, {event_id: event.id, team: invalid_parameters}, valid_session_admin
            expect(response).to have_http_status(:bad_request)
          end
        end
      end

      context 'as not a admin' do
        it 'returns HTTP status 403 (Forbidden)' do
          post :create, {event_id: event.id, team: valid_parameters}, valid_session
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'while logged out' do
      it 'returns HTTP status 403 (Forbidden)' do
        post :create, event_id: event.id, team: valid_parameters
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PUT #update' do
    context 'with a valid team' do
      context 'as an admin' do
        context 'with valid parameters' do
          before do
            put :update, {event_id: team.event.id, id: team.id, team: valid_parameters}, valid_session_admin
          end

          it 'returns HTTP status 200 (OK)' do
            expect(response).to have_http_status(:ok)
          end

          it 'updates the requested team' do
            team.reload
            expect(team.name).to eq(valid_parameters[:name])
          end
        end

        context 'with invalid parameters' do
          it 'returns HTTP status 400 (Bad Request)' do
            put :update, {event_id: team.event.id, id: team.id, team: invalid_parameters}, valid_session_admin
            expect(response).to have_http_status(:bad_request)
          end
        end
      end

      context 'not as an admin' do
        context 'as a team member' do
          it 'returns HTTP status 200 (OK)' do
            put :update, {event_id: team.event.id, id: team.id, team: valid_parameters}, valid_session_team_member
            expect(response).to have_http_status(:forbidden)
          end
        end

        context 'not as a team member' do
          it 'returns HTTP status 403 (Forbidden)' do
            put :update, {event_id: team.event.id, id: team.id, team: valid_parameters}, valid_session
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    context 'with an invalid team' do
      it 'returns HTTP status 404 (Not Found)' do
        put :update, {event_id: team.event.id, id: -1, team: valid_parameters}, valid_session_admin
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with a valid team' do
      context 'as an admin' do
        it 'returns HTTP status 200 (OK)' do
          delete :destroy, {event_id: team.event.id, id: team.id}, valid_session_admin
          expect(response).to have_http_status(:ok)
        end

        it 'deletes the requested team' do
          team_to_remove = FactoryGirl.create(:team)
          expect do
            delete :destroy, {event_id: team_to_remove.event.id, id: team_to_remove.id}, valid_session_admin
          end.to change { Team.count }.by(-1)
        end
      end

      context 'not as an admin' do
        it 'returns HTTP status 403 (Forbidden)' do
          put :destroy, {event_id: team.event.id, id: team.id}, valid_session
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'with an invalid team' do
      it 'returns HTTP status 404 (Not Found)' do
        delete :destroy, event_id: team.event.id, id: -1
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
