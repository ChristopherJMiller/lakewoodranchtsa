class AwardsController < ApplicationController
  respond_to :html, :json

  def index
    @awards = Award.all
    respond_with @awards
  end

  def show
    @award = Award.find_by_user_id_and_id(params[:user_id], params[:id])
    if @award
      respond_with @award
    else
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
  end

  def new
    @award = Award.new
    respond_to :html
  end

  def edit
    @award = Award.find_by_user_id_and_id(params[:user_id], params[:id])
    if @award
      respond_with @award
    else
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
  end

  def create
    if session[:user_id].nil?
      head status: :forbidden and return
    end
    if !User.find_by_id(session[:user_id]).is_member
      head status: :forbidden and return
    end
    award = Award.new(award_parameters_create)
    if award.save
      head status: :created, location: user_award_path(award.user, award)
    else
      render json: {error: award.errors}, status: :bad_request
    end
  end

  def update
    award = Award.find_by_id(params[:id])
    if !award
      head status: :not_found and return
    end
    if session[:user_id].nil? or !User.find_by_id(session[:user_id]).is_admin
      head status: :forbidden and return
    end
    if award.update(award_parameters_update)
      head status: :ok
    else
      render json: {error: award.errors}, status: :bad_request
    end
  end

  def destroy
    award = Award.find_by_id(params[:id])
    if !award
      head status: :not_found and return
    end
    if session[:user_id].nil? or !User.find_by_id(session[:user_id]).is_admin
      head status: :forbidden and return
    end
    Award.destroy(award.id)
    head status: :ok
  end

  private

  def award_parameters_create
    parameters = params.require(:award).permit(:name)
    parameters[:user_id] = session[:user_id]
    parameters[:value] = 0
    parameters[:verified] = false
    return parameters
  end

  def award_parameters_update
    params.require(:award).permit(:name, :value, :verified)
  end
end
