# Controller for managing user logged in sessions
class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    errors = ActiveModel::Errors.new(self)

    if user && user.authenticate(params[:password]) && !user.disabled?
      session[:user_id] = user.id
      head status: :created
    else
      if user && user.disabled?
        errors.add(:email, 'This account is disabled')
      else
        errors.add(:password, 'Invalid email and password combination')
      end
      render json: {error: errors}, status: :bad_request
    end
  end

  def destroy
    reset_session
    head status: :ok
  end
end
