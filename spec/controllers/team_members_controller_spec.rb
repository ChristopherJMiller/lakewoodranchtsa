require 'rails_helper'

RSpec.describe TeamMembersController, type: :controller do

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

    let(:team_member) do
      FactoryGirl.create(:team_member, user_id: user_member.id, admin: false)
    end

    let(:team_member_admin) do
      FactoryGirl.create(:team_member, team_id: team_member.team.id, user_id: different_user.id, admin: true)
    end

    let(:event) do
      FactoryGirl.create(:event)
    end

    let(:team) do
      FactoryGirl.create(:team)
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

    let(:valid_parameters) do
      {user_id: user.id}
    end

    let(:valid_parameters_member) do
      {user_id: user_member.id, admin: false}
    end

    let(:valid_update_parameters) do
      {admin: true}
    end

    let(:invalid_update_parameters) do
      {admin: nil}
    end

    let(:invalid_parameters) do
      {user_id: -1, admin: false}
    end

    let(:valid_session_existing_team_member) do
      {user_id: team_member_admin.user.id}
    end

    let(:valid_session_existing_member_not_admin) do
      {user_id: team_member.user.id}
    end

    describe 'GET #index' do
      it 'assigns all members of a team to @team_members' do
        get :index, {event_id: team_member.team.event.id, team_id: team_member.team.id}
        expect(assigns(:team_members)).to eq([team_member])
      end
    end

    describe 'GET #new' do
      it 'assigns a new team member as @team_member' do
        get :new, {event_id: team_member.team.event.id, team_id: team_member.team.id, id: team_member.id}
        expect(assigns(:team_member)).to be_a_new(TeamMember)
      end
    end

    describe 'GET #edit' do
      context 'with a valid team member' do
        before(:each) do
          get :edit, {event_id: team_member.team.event.id, team_id: team_member.team.id, id: team_member.id}
        end

        it 'returns HTTP status 200 (OK)' do
          expect(response).to have_http_status(:ok)
        end

        it 'assigns the requested team member as @team_member' do
          expect(assigns(:team_member)).to eq(team_member)
        end
      end

      context 'with an invalid team' do
        it 'returns HTTP status 404 (Not Found)' do
          expect {
            get :edit, {event_id: team_member.team.event.id, team_id: team_member.team.id, id: -1}
          }.to raise_error(ActionController::RoutingError)
        end
      end
    end

  describe 'POST #create' do
    context 'with valid parameters' do
      context 'as a logged in user' do
        context 'when the user is a site admin' do
          it 'returns HTTP status 201 (Created)' do
            post :create, {event_id: event.id, team_id: team.id, team_member: valid_parameters_member}, valid_session_admin
            expect(response).to have_http_status(:created)
          end

          it 'creates a new team member' do
            expect {
              post :create, {event_id: event.id, team_id: team.id, team_member: valid_parameters_member}, valid_session_admin
            }.to change(TeamMember, :count).by(1)
          end
        end

        context 'while the user is already a team member' do
          it 'returns HTTP status 409 (Conflict)' do
            post :create, {event_id: event.id, team_id: team.id, team_member: valid_parameters_member}, valid_session_admin
            post :create, {event_id: event.id, team_id: team.id, team_member: valid_parameters_member}, valid_session_admin
            expect(response).to have_http_status(:conflict)
          end
        end

        context 'when the user is not a site admin' do
          it 'returns a HTTP status 403 (Forbidden)' do
            post :create, {event_id: event.id, team_id: team.id, team_member: valid_parameters}, valid_session_member
            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      context 'as a logged out user' do
        it 'returns HTTP status 403 (Forbidden)' do
          post :create, {event_id: event.id, team_id: team.id, team_member: valid_parameters_member}
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'with invalid parameters' do
      it 'returns HTTP status 403 (Forbidden)' do
        post :create, {event_id: event.id, team_id: team.id, team_member: invalid_parameters}, valid_session_member
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PUT #update' do
    context 'with a valid member' do
      context 'with valid parameters' do
        context 'as a team admin' do
          before (:each) do
            put :update, {event_id: team_member.team.event.id, team_id: team_member.team.id, id: team_member.id, team_member: valid_update_parameters}, valid_session_existing_team_member
          end

          it 'returns HTTP status 200 (OK)' do
            expect(response).to have_http_status(:ok)
          end

          it 'updates the requested member' do
            team_member.reload
            expect(team_member.admin).to eq(valid_update_parameters[:admin])
          end
        end

        context 'not as a team admin' do
          it 'returns HTTP status 403 (Forbidden)' do
            put :update, {event_id: team_member.team.event.id, team_id: team_member.team.id, id: team_member.id, team_member: valid_update_parameters}, valid_session_existing_member_not_admin
            expect(response).to have_http_status(:forbidden)
          end
        end

        context 'as a site admin' do
          before (:each) do
            put :update, {event_id: team_member.team.event.id, team_id: team_member.team.id, id: team_member.id, team_member: valid_update_parameters}, valid_session_admin
          end

          it 'returns HTTP status 200 (OK)' do
            expect(response).to have_http_status(:ok)
          end

          it 'updates the requested member' do
            team_member.reload
            expect(team_member.admin).to eq(valid_update_parameters[:admin])
          end
        end
      end

      context 'with invalid parameters' do
        it 'returns HTTP status 400 (Bad Request)' do
          put :update, {event_id: team_member_admin.team.event.id, team_id: team_member_admin.team.id, id: team_member_admin.id, team_member: invalid_update_parameters}, valid_session_existing_team_member
          expect(response).to have_http_status(:bad_request)
        end
      end
    end

    context 'with an invalid member' do
      it 'returns HTTP status 404 (Not Found)' do
        put :update, {event_id: team_member_admin.team.event.id, team_id: team_member_admin.team.id, id: -1, team_member: valid_update_parameters}, valid_session_existing_team_member
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with a valid team' do
      context 'as an admin' do
        it 'returns HTTP status 200 (OK)' do
          delete :destroy, {event_id: team_member.team.event.id, team_id: team_member.team.id, id: team_member.id}, valid_session_admin
          expect(response).to have_http_status(:ok)
        end

        it 'deletes the requested member' do
          team_member_to_delete = FactoryGirl.create(:team_member, user_id: user_member.id)
          expect {
            delete :destroy, {event_id: team_member_to_delete.team.event.id, team_id: team_member_to_delete.team.id, id: team_member_to_delete.id}, valid_session_admin
          }.to change(TeamMember, :count).by(-1)
        end
      end

      context 'not as an admin' do
        context 'as the requested participant' do
          it 'returns HTTP status 200 (OK)' do
            delete :destroy, {event_id: team_member.team.event.id, team_id: team_member.team.id, id: team_member.id}, valid_session_existing_team_member
            expect(response).to have_http_status(:ok)
          end

          it 'deletes the requested participant' do
            team_member_to_delete = FactoryGirl.create(:team_member, user_id: user_member.id)
            expect {
              delete :destroy, {event_id: team_member_to_delete.team.event.id, team_id: team_member_to_delete.team.id, id: team_member_to_delete.id}, {user_id: team_member_to_delete.user.id}
            }.to change(TeamMember, :count).by(-1)
          end
        end

        context 'not as the requested participant' do
          it 'returns HTTP status 403 (Forbidden)' do
            team_member_to_delete = FactoryGirl.create(:team_member)
            delete :destroy, {event_id: team_member_to_delete.team.event.id, team_id: team_member_to_delete.team.id, id: team_member_to_delete.id}, {user_id: different_user.id}
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    context 'with an invalid participant' do
      it 'returns HTTP status 404 (Not Found)' do
        delete :destroy, {event_id: team_member.team.event.id, team_id: team_member.team.id, id: -1}, valid_session_existing_team_member
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
