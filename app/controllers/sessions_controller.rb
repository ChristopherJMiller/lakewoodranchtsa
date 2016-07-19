class SessionsController < ApplicationController

  def create
    user = User.find_by_email(params[:email])
    errors = ActiveModel::Errors.new(self)

    if user && user.authenticate(params[:password]) && user.verified
      session[:user_id] = user.id
      head status: :created
    else
      if user && !user.verified
        errors.add(:email, "This user is not verified, please check your email.")
      end
      if !user
        errors.add(:password, "Invalid email and password combination")
      end
      render json: {error: errors}, status: :bad_request
    end
  end

  def destroy
    reset_session
    head status: :ok
  end
end
