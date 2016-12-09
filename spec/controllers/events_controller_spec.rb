require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:valid_parameters) do
    {name: 'Test Event', description: 'Test description', max_members_per_team: 6}
  end

  let(:invalid_parameters) do
    {name: nil, description: 'Test description', max_members_per_team: 6}
  end

  let(:event) do
    FactoryGirl.create(:event)
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
    it 'assigns all events as @events' do
      event = FactoryGirl.create(:event)
      get :index
      expect(assigns(:events)).to eq([event])
    end
  end

  describe 'GET #show' do
    context 'with a valid event' do
      before do
        get :show, id: event.id
      end

      it 'returns HTTP status 200 (OK)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns the requested event as @event' do
        expect(assigns(:event)).to eq(event)
      end
    end

    context 'with an invalid event' do
      it 'returns HTTP status 404 (Not Found)' do
        expect do
          get :show, id: -1
        end.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe 'GET #new' do
    it 'assigns a new event as @event' do
      get :new
      expect(assigns(:event)).to be_a_new(Event)
    end
  end

  describe 'GET #edit' do
    context 'with a valid event' do
      before do
        get :edit, id: event.id
      end

      it 'returns HTTP status 200 (OK)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns the requested event as @event' do
        expect(assigns(:event)).to eq(event)
      end
    end

    context 'with an invalid event' do
      it 'returns HTTP status 404 (Not Found)' do
        expect do
          get :edit, id: -1
        end.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe 'POST #create' do
    context 'while logged in' do
      context 'as an admin' do
        context 'with valid parameters' do
          it 'returns HTTP status 201 (Created)' do
            post :create, {event: valid_parameters}, valid_session_admin
            expect(response).to have_http_status(:created)
          end

          it 'creates a new event' do
            expect do
              post :create, {event: valid_parameters}, valid_session_admin
            end.to change(Event, :count).by(1)
          end
        end

        context 'with invalid parameters' do
          it 'returns HTTP status 400 (Bad Request)' do
            post :create, {event: invalid_parameters}, valid_session_admin
            expect(response).to have_http_status(:bad_request)
          end
        end
      end

      context 'as not an admin' do
        it 'returns HTTP status 403 (Forbidden)' do
          post :create, {event: valid_parameters}, valid_session
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'while logged out' do
      it 'returns HTTP status 403 (Forbidden)' do
        post :create, event: valid_parameters
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PUT #update' do
    context 'with a valid event' do
      context 'as an admin' do
        context 'with valid parameters' do
          before do
            put :update, {id: event.id, event: valid_parameters}, valid_session_admin
          end

          it 'returns HTTP status 200 (OK)' do
            expect(response).to have_http_status(:ok)
          end

          it 'updates the requested event\'s name' do
            event.reload
            expect(event.name).to eq(valid_parameters[:name])
          end

          it 'updates the requested event\'s description' do
            event.reload
            expect(event.description).to eq(valid_parameters[:description])
          end

          it 'updates the requested event\'s max members per team' do
            event.reload
            expect(event.max_members_per_team).to eq(valid_parameters[:max_members_per_team])
          end
        end

        context 'with invalid parameters' do
          it 'returns HTTP status 400 (Bad Request)' do
            put :update, {id: event.id, event: invalid_parameters}, valid_session_admin
            expect(response).to have_http_status(:bad_request)
          end
        end
      end

      context 'not as an admin' do
        it 'returns HTTP status 403 (Forbidden)' do
          put :update, {id: event.id, event: valid_parameters}, valid_session
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'with an invalid event' do
      it 'returns HTTP status 404 (Not Found)' do
        put :update, {id: -1, event: valid_parameters}, valid_session_admin
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with a valid event' do
      context 'as an admin' do
        it 'returns HTTP status 200 (OK)' do
          delete :destroy, {id: event.id}, valid_session_admin
          expect(response).to have_http_status(:ok)
        end

        it 'deletes the requested event' do
          event_to_remove = FactoryGirl.create(:event)
          expect do
            delete :destroy, {id: event_to_remove.id}, valid_session_admin
          end.to change { Event.count }.by(-1)
        end
      end

      context 'not as an admin' do
        it 'returns HTTP status 403 (Forbidden)' do
          put :destroy, {id: event.id}, valid_session
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'with an invalid event' do
      it 'returns HTTP status 404 (Not Found)' do
        delete :destroy, id: 1
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
