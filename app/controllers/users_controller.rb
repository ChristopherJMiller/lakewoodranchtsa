# Controller for User routes
class UsersController < ApplicationController
  respond_to :html, :json

  add_breadcrumb 'Users', :users_path

  def index
    @users = User.all
    respond_with @users
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user
      add_breadcrumb @user.name, user_path(@user)
      respond_with @user
    else
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
  end

  def new
    @user = User.new
    add_breadcrumb 'Register', new_user_path
    respond_to :html
  end

  def edit
    @user = User.find_by(id: params[:id])
    if @user
      add_breadcrumb @user.name, user_path(@user)
      add_breadcrumb 'Settings', edit_user_path(@user)
      return head status: :forbidden unless !logged_in || current_user.admin? || @user.id == session[:user_id]
      respond_with @user
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
    return head status: :forbidden unless logged_in

    # Nonadmin users shouldn't be able to change other users.
    if !current_user.admin? && (params[:user][:rank].present? || params[:id].to_i != session[:user_id])
      return head status: :forbidden
    end

    user = User.find_by(id: params[:id])

    return head status: :not_found unless user
    return head status: :forbidden if current_user.officer? && user.admin?

    if user.update(user_parameters_update)
      head status: :ok
    else
      render json: {error: user.errors}, status: :bad_request
    end
  end

  def change_password
    user = User.find_by(id: params[:user_id])
    return head status: :not_found unless user

    if user.id != session[:user_id] || session[:user_id].nil?
      return head status: :forbidden
    end
    if user.update(user_parameters_change_password)
      head status: :ok
    else
      render json: {error: user.errors}, status: :bad_request
    end
  end

  def verify_email
    user = User.find_by(verify_token: params[:token])
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
    parameters[:disabled] = false
    parameters
  end

  def user_parameters_update
    params.require(:user).permit(:name, :rank, :disabled)
  end

  def user_parameters_change_password
    params.require(:user).permit(:password, :password_confirmation)
  end
end
