require 'rails_helper'

RSpec.describe DocumentsController, type: :controller do
  let(:valid_parameters) do
    {title: 'Test Document', link: 'www.google.com'}
  end

  let(:invalid_parameters) do
    {title: nil, link: 'www.google.com'}
  end

  let(:document) do
    FactoryGirl.create(:document)
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
    it 'assigns all documents as @documents' do
      document = FactoryGirl.create(:document)
      get :index
      expect(assigns(:documents)).to eq([document])
    end
  end

  describe 'GET #show' do
    context 'with a valid document' do
      before do
        get :show, id: document.id
      end

      it 'returns HTTP status 302 (FOUND)' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to the document\'s link' do
        expect(response).to redirect_to(document.link)
      end
    end

    context 'with an invalid document' do
      it 'returns HTTP status 404 (Not Found)' do
        expect do
          get :show, id: -1
        end.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe 'GET #new' do
    it 'assigns a new document as @document' do
      get :new
      expect(assigns(:document)).to be_a_new(Document)
    end
  end

  describe 'GET #edit' do
    context 'with a valid event' do
      before do
        get :edit, id: document.id
      end

      it 'returns HTTP status 200 (OK)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns the requested document as @document' do
        expect(assigns(:document)).to eq(document)
      end
    end

    context 'with an invalid document' do
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
            post :create, {document: valid_parameters}, valid_session_admin
            expect(response).to have_http_status(:created)
          end

          it 'creates a new document' do
            expect do
              post :create, {document: valid_parameters}, valid_session_admin
            end.to change(Document, :count).by(1)
          end
        end

        context 'with invalid parameters' do
          it 'returns HTTP status 400 (Bad Request)' do
            post :create, {document: invalid_parameters}, valid_session_admin
            expect(response).to have_http_status(:bad_request)
          end
        end
      end

      context 'as not an admin' do
        it 'returns HTTP status 403 (Forbidden)' do
          post :create, {document: valid_parameters}, valid_session
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'while logged out' do
      it 'returns HTTP status 403 (Forbidden)' do
        post :create, document: valid_parameters
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PUT #update' do
    context 'with a valid document' do
      context 'as an admin' do
        context 'with valid parameters' do
          before do
            put :update, {id: document.id, document: valid_parameters}, valid_session_admin
          end

          it 'returns HTTP status 200 (OK)' do
            expect(response).to have_http_status(:ok)
          end

          it 'updates the requested document title' do
            document.reload
            expect(document.title).to eq(valid_parameters[:title])
          end

          it 'updates the requested document link' do
            document.reload
            expect(document.link).to eq(valid_parameters[:link])
          end
        end

        context 'with invalid parameters' do
          it 'returns HTTP status 400 (Bad Request)' do
            put :update, {id: document.id, document: invalid_parameters}, valid_session_admin
            expect(response).to have_http_status(:bad_request)
          end
        end
      end

      context 'not as an admin' do
        it 'returns HTTP status 403 (Forbidden)' do
          put :update, {id: document.id, document: valid_parameters}, valid_session
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'with an invalid document' do
      it 'returns HTTP status 404 (Not Found)' do
        put :update, {id: -1, document: valid_parameters}, valid_session_admin
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with a valid document' do
      context 'as an admin' do
        it 'returns HTTP status 200 (OK)' do
          delete :destroy, {id: document.id}, valid_session_admin
          expect(response).to have_http_status(:ok)
        end

        it 'deletes the requested event' do
          document_to_remove = FactoryGirl.create(:document)
          expect do
            delete :destroy, {id: document_to_remove.id}, valid_session_admin
          end.to change { Document.count }.by(-1)
        end
      end

      context 'not as an admin' do
        it 'returns HTTP status 403 (Forbidden)' do
          put :destroy, {id: document.id}, valid_session
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'with an invalid document' do
      it 'returns HTTP status 404 (Not Found)' do
        delete :destroy, id: 1
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
