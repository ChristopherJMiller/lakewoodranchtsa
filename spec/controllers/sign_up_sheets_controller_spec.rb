require 'rails_helper'

RSpec.describe SignUpSheetsController, type: :controller do
  let(:valid_parameters) do
    {name: 'Sign Up Sheet', date: '2016-07-01'}
  end

  let(:invalid_parameters) do
    {name: nil, date: '2016-07-01'}
  end

  let(:sign_up_sheet) do
    FactoryGirl.create(:sign_up_sheet)
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
    it 'assigns all sign up sheets as @sign_up_sheets' do
      sign_up_sheets = FactoryGirl.create(:sign_up_sheet)
      get :index
      expect(assigns(:sign_up_sheets)).to eq([sign_up_sheets])
    end
  end

  describe 'GET #show' do
    context 'with a valid sign up sheet' do
      before do
        get :show, id: sign_up_sheet.id
      end

      it 'returns HTTP status 200 (OK)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns the requested sign up sheet as @sign_up_sheet' do
        expect(assigns(:sign_up_sheet)).to eq(sign_up_sheet)
      end
    end

    context 'with an invalid sign up sheet' do
      it 'returns HTTP status 404 (Not Found)' do
        expect do
          get :show, id: -1
        end.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe 'GET #new' do
    it 'assigns a new sign up sheet as @sign_up_sheet' do
      get :new
      expect(assigns(:sign_up_sheet)).to be_a_new(SignUpSheet)
    end
  end

  describe 'GET #edit' do
    context 'with a valid sign up sheet' do
      before do
        get :edit, id: sign_up_sheet.id
      end

      it 'returns HTTP status 200 (OK)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns the requested sign up sheet as @sign_up_sheet' do
        expect(assigns(:sign_up_sheet)).to eq(sign_up_sheet)
      end
    end

    context 'with an invalid sign up sheet' do
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
            post :create, {sign_up_sheet: valid_parameters}, valid_session_admin
            expect(response).to have_http_status(:created)
          end

          it 'creates a new sign up sheet' do
            expect do
              post :create, {sign_up_sheet: valid_parameters}, valid_session_admin
            end.to change(SignUpSheet, :count).by(1)
          end
        end

        context 'with invalid parameters' do
          it 'returns HTTP status 400 (Bad Request)' do
            post :create, {sign_up_sheet: invalid_parameters}, valid_session_admin
            expect(response).to have_http_status(:bad_request)
          end
        end
      end

      context 'as not an admin' do
        it 'returns HTTP status 403 (Forbidden)' do
          post :create, {sign_up_sheet: valid_parameters}, valid_session
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'while logged out' do
      it 'returns HTTP status 403 (Forbidden)' do
        post :create, sign_up_sheet: valid_parameters
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PUT #update' do
    context 'with a valid sign up sheet' do
      context 'as an admin' do
        context 'with valid parameters' do
          before do
            put :update, {id: sign_up_sheet.id, sign_up_sheet: valid_parameters}, valid_session_admin
          end

          it 'returns HTTP status 200 (OK)' do
            expect(response).to have_http_status(:ok)
          end

          it 'updates the requested sign up sheet name' do
            sign_up_sheet.reload
            expect(sign_up_sheet.name).to eq(valid_parameters[:name])
          end

          it 'updates the requested sign up sheet date' do
            sign_up_sheet.reload
            expect(sign_up_sheet.date).to eq(valid_parameters[:date].to_date)
          end
        end

        context 'with invalid parameters' do
          it 'returns HTTP status 400 (Bad Request)' do
            put :update, {id: sign_up_sheet.id, sign_up_sheet: invalid_parameters}, valid_session_admin
            expect(response).to have_http_status(:bad_request)
          end
        end
      end

      context 'not as an admin' do
        it 'returns HTTP status 403 (Forbidden)' do
          put :update, {id: sign_up_sheet.id, sign_up_sheet: valid_parameters}, valid_session
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'with an invalid sign up sheet' do
      it 'returns HTTP status 404 (Not Found)' do
        put :update, {id: -1, sign_up_sheet: valid_parameters}, valid_session_admin
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with a valid sign up sheet' do
      context 'as an admin' do
        before do
          Attendee.create(sign_up_sheet_id: sign_up_sheet.id, user_id: user.id)
        end

        it 'returns HTTP status 200 (OK)' do
          delete :destroy, {id: sign_up_sheet.id}, valid_session_admin
          expect(response).to have_http_status(:ok)
        end

        it 'deletes the requested sign up sheet' do
          expect do
            delete :destroy, {id: sign_up_sheet.id}, valid_session_admin
          end.to change(SignUpSheet, :count).by(-1)
        end
      end

      context 'not as an admin' do
        it 'returns HTTP status 403 (Forbidden)' do
          put :destroy, {id: sign_up_sheet.id}, valid_session
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'with an invalid sign up sheet' do
      it 'returns HTTP status 404 (Not Found)' do
        delete :destroy, id: 1
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
