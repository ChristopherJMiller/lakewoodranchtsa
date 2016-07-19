class UsersController < ApplicationController
  respond_to :html, :json

  def index
    @users = User.all
    respond_with @users
  end

  def show
    @user = User.find_by_id(params[:id])
    if !@user
      head status: :not_found and return
    end
    respond_with @user
  end

  def new
    @user = User.new
    respond_to :html
  end

  def edit
    @user = User.find_by_id(params[:id])
    if @user
      if @user.id != session[:user_id]
        head status: :forbidden and return
      else
        respond_with @user
      end
    else
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
  end

  def create
    user = User.new(user_parameters_create)

    if user.save
      Notifier.verify_email(user).deliver_now
      head status: :created
    else
      render json: {error: user.errors}, status: :bad_request
    end
  end

  def update
    user = User.find_by_id(params[:id])
    if !user
      head status: :not_found and return
    end
    if (session[:user_id].nil? or user.id != session[:user_id]) and (User.find_by_id(session[:user_id]).nil? or User.find_by_id(session[:user_id]).rank < 2)
      head status: :forbidden and return
    end
    if user.update(user_parameters_update)
      head status: :ok
    else
      render json: {error: user.errors}, status: :bad_request
    end
  end

  def change_password
    user = User.find_by_id(params[:user_id])
    if !user
      head status: :not_found and return
    end
    if user.id != session[:user_id] or session[:user_id].nil?
      head status: :forbidden and return
    end
    if user.update(user_parameters_change_password)
      head status: :ok
    else
      render json: {error: user.errors}, status: :bad_request
    end
  end

  def verify_email
    user = User.find_by_verify_token(params[:token])
    if user
      user.update_attribute(:verified, true)
      respond_to :html
    else
      head status: :bad_request
    end
  end

  private

  def user_parameters_create
    parameters = params.require(:user).permit(:name, :email, :password, :password_confirmation)
    parameters[:verified] = false
    parameters[:rank] = 0
    return parameters
  end

  def user_parameters_update
    params.require(:user).permit(:name, :rank)
  end

  def user_parameters_change_password
    params.require(:user).permit(:password, :password_confirmation)
  end
end
