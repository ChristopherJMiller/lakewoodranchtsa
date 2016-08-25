class AccountabilitylogsController < ApplicationController
  respond_to :html, :json

  def index
    @accountabilitylogs = Accountabilitylog.all
    respond_with @accountabilitylogs
  end

  def show
    @accountabilitylog = Accountabilitylog.find_by_id(params[:id])
    if @accountabilitylog
      respond_with @accountabilitylog
    else
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
  end

  def new
    @accountabilitylog = Accountabilitylog.new
    respond_to :html
  end

  def edit
    @accountabilitylog = Accountabilitylog.find_by_id(params[:id])
    if @accountabilitylog
      respond_with @accountabilitylog
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
    if !User.find_by_id(session[:user_id]).is_admin
      head status: :forbidden and return
    end
    accountabilitylog = Accountabilitylog.new(accountabilitylog_parameters_create)
    if accountabilitylog.save
      head status: :created, location: accountabilitylog_path(accountabilitylog)
    else
      render json: {error: accountabilitylog.errors}, status: :bad_request
    end
  end

  def update
    accountabilitylog = Accountabilitylog.find_by_id(params[:id])
    if !accountabilitylog
      head status: :not_found and return
    end
    if session[:user_id].nil? or !User.find_by_id(session[:user_id]).is_admin
      head status: :forbidden and return
    end
    if accountabilitylog.update(accountabilitylog_parameters_update)
      head status: :ok
    else
      render json: {error: accountabilitylog.errors}, status: :bad_request
    end
  end

  def destroy
    accountabilitylog = Accountabilitylog.find_by_id(params[:id])
    if !accountabilitylog
      head status: :not_found and return
    end
    if session[:user_id].nil? or !User.find_by_id(session[:user_id]).is_admin
      head status: :forbidden and return
    end
    Accountabilitylog.destroy(accountabilitylog.id)
    head status: :ok
  end

  private

  def accountabilitylog_parameters_create
    params.require(:accountabilitylog).permit(:dueby, :closingdate)
  end

  def accountabilitylog_parameters_update
    params.require(:accountabilitylog).permit(:dueby, :closingdate)
  end
end
