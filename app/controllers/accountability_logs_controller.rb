class AccountabilityLogsController < ApplicationController
  respond_to :html, :json

  add_breadcrumb "Accountability Logs", :accountability_logs_path

  def index
    @accountability_logs = AccountabilityLog.all
    respond_with @accountability_logs
  end

  def show
    @accountability_log = AccountabilityLog.find_by_id(params[:id])
    add_breadcrumb "Accountability Log #" + @accountability_log.id.to_s, accountability_log_path(@accountability_log)
    add_breadcrumb "Submissions", accountability_log_path(@accountability_log)
    if @accountability_log
      respond_with @accountability_log
    else
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
  end

  def new
    @accountability_log = AccountabilityLog.new
    add_breadcrumb "New Accountability Log", new_accountability_log_path
    respond_to :html
  end

  def edit
    @accountability_log = AccountabilityLog.find_by_id(params[:id])
    add_breadcrumb "Edit Accountability Log #" + @accountability_log.id.to_s, edit_accountability_log_path(@accountability_log)
    if @accountability_log
      respond_with @accountability_log
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
    accountability_log = AccountabilityLog.new(accountability_log_parameters_create)
    if accountability_log.save
      head status: :created, location: accountability_log_path(accountability_log)
    else
      render json: {error: accountability_log.errors}, status: :bad_request
    end
  end

  def update
    accountability_log = AccountabilityLog.find_by_id(params[:id])
    if !accountability_log
      head status: :not_found and return
    end
    if session[:user_id].nil? or !User.find_by_id(session[:user_id]).is_admin
      head status: :forbidden and return
    end
    if accountability_log.update(accountability_log_parameters_update)
      head status: :ok
    else
      render json: {error: accountability_log.errors}, status: :bad_request
    end
  end

  def destroy
    accountability_log = AccountabilityLog.find_by_id(params[:id])
    if !accountability_log
      head status: :not_found and return
    end
    if session[:user_id].nil? or !User.find_by_id(session[:user_id]).is_admin
      head status: :forbidden and return
    end
    AccountabilityLog.destroy(accountability_log.id)
    head status: :ok
  end

  private

  def accountability_log_parameters_create
    params.require(:accountability_log).permit(:dueby, :closingdate)
  end

  def accountability_log_parameters_update
    params.require(:accountability_log).permit(:dueby, :closingdate)
  end
end
