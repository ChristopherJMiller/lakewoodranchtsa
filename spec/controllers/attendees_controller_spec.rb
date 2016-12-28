require 'rails_helper'

RSpec.describe AttendeesController, type: :controller do
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

  let(:attendee) do
    FactoryGirl.create(:attendee)
  end

  let(:sign_up_sheet) do
    FactoryGirl.create(:sign_up_sheet)
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
    {user_id: user_member.id}
  end

  let(:invalid_parameters) do
    {user_id: -1}
  end

  let(:valid_session_existing_attendee) do
    {user_id: attendee.user.id}
  end

  describe 'GET #index' do
    it 'assigns all members of a sign up sheet to @attendees' do
      get :index, sign_up_sheet_id: attendee.sign_up_sheet.id
      expect(assigns(:attendees)).to eq([attendee])
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      context 'as a logged in user' do
        context 'when the user is an admin' do
          context 'while the user is not a attendee' do
            it 'returns HTTP status 201 (Created)' do
              post :create, {sign_up_sheet_id: sign_up_sheet.id, attendee: valid_parameters_member}, valid_session_admin
              expect(response).to have_http_status(:created)
            end

            it 'creates a new attendee' do
              expect do
                post :create, {sign_up_sheet_id: sign_up_sheet.id, attendee: valid_parameters_member}, valid_session_admin
              end.to change(Attendee, :count).by(1)
            end
          end

          context 'while the user is a attendee' do
            it 'returns HTTP status 409 (Conflict)' do
              post :create, {sign_up_sheet_id: sign_up_sheet.id, attendee: valid_parameters_member}, valid_session_admin
              post :create, {sign_up_sheet_id: sign_up_sheet.id, attendee: valid_parameters_member}, valid_session_admin
              expect(response).to have_http_status(:conflict)
            end
          end
        end

        context 'when the user is not an admin' do
          it 'returns a HTTP status 403 (Forbidden)' do
            post :create, {sign_up_sheet_id: sign_up_sheet.id, attendee: valid_parameters}, valid_session_member
            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      context 'as a logged out user' do
        it 'returns HTTP status 403 (Forbidden)' do
          post :create, sign_up_sheet_id: sign_up_sheet.id, attendee: valid_parameters_member
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'with invalid parameters' do
      it 'returns HTTP status 403 (Forbidden)' do
        post :create, {sign_up_sheet_id: sign_up_sheet.id, attendee: invalid_parameters}, valid_session_admin
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with a valid event' do
      context 'as an admin' do
        it 'returns HTTP status 200 (OK)' do
          delete :destroy, {sign_up_sheet_id: attendee.sign_up_sheet.id, id: attendee.id}, valid_session_admin
          expect(response).to have_http_status(:ok)
        end

        it 'deletes the requested member' do
          attendee_to_delete = FactoryGirl.create(:attendee)
          expect do
            delete :destroy, {sign_up_sheet_id: attendee_to_delete.sign_up_sheet.id, id: attendee_to_delete.id}, valid_session_admin
          end.to change(Attendee, :count).by(-1)
        end
      end

      context 'not as an admin' do
        context 'as the requested attendee' do
          it 'returns HTTP status 200 (OK)' do
            delete :destroy, {sign_up_sheet_id: attendee.sign_up_sheet.id, id: attendee.id}, valid_session_existing_attendee
            expect(response).to have_http_status(:ok)
          end

          it 'deletes the requested attendee' do
            attendee_to_delete = FactoryGirl.create(:attendee)
            expect do
              delete :destroy, {sign_up_sheet_id: attendee_to_delete.sign_up_sheet.id, id: attendee_to_delete.id}, user_id: attendee_to_delete.user.id
            end.to change(Attendee, :count).by(-1)
          end
        end

        context 'not as the requested attendee' do
          it 'returns HTTP status 403 (Forbidden)' do
            delete :destroy, {sign_up_sheet_id: attendee.sign_up_sheet.id, id: attendee.id}, user_id: different_user.id
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    context 'with an invalid attendee' do
      it 'returns HTTP status 404 (Not Found)' do
        delete :destroy, {sign_up_sheet_id: attendee.sign_up_sheet.id, id: -1}, valid_session_existing_attendee
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
