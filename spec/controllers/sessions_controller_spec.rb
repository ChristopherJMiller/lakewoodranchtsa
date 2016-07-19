require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:valid_parameters) {
    {name: 'John Doe', email: 'test@test.com', password: 'password1234', password_confirmation: 'password1234', verified: true}
  }

  let(:invalid_parameters) {
    {name: 'John Doe', email: 'test@test.com', password: 'password12345', password_confirmation: 'password1234', verified: true}
  }

  describe 'POST #create' do
    context 'with valid parameters' do
      before do
        FactoryGirl.create(:user)
      end

      it 'returns HTTP status 201 (Created)' do
        post :create, valid_parameters
        expect(response).to have_http_status(:created)
      end

      it 'creates a new session' do
        post :create, valid_parameters
        expect(session[:user_id]).to_not be_nil
      end
    end

    context 'with invalid parameters' do
      it 'returns HTTP status 400 (Bad Request)' do
        post :create, invalid_parameters
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'returns HTTP status 200 (OK)' do
      delete :destroy
      expect(response).to have_http_status(:ok)
    end

    it 'destroys the current session' do
      session[:user_id] = 1
      delete :destroy
      expect(session[:user_id]).to be_nil
    end
  end
end
