class SubmissionsController < ApplicationController
  respond_to :html, :json
  before_action :define_breadcrumb

  def define_breadcrumb
    add_breadcrumb "Accountability Logs", :accountability_logs_path
    @accountability_log = AccountabilityLog.find_by_id(params[:accountability_log_id])
    add_breadcrumb "Accountability Log #" + @accountability_log.id.to_s, accountability_log_path(@accountability_log)
    add_breadcrumb "Submissions", accountability_log_path(@accountability_log)
  end

  def index
    if session[:user_id].nil? or !User.find_by_id(session[:user_id]).is_admin
      head status: :forbidden and return
    end
    @submissions = AccountabilityLog.find_by_id(params[:accountability_log_id]).submissions
    respond_with @submissions
  end

  def edit
    @submission = Submission.find_by_accountability_log_id_and_id(params[:accountability_log_id], params[:id])
    if @submission
      add_breadcrumb "Edit Submission by " + @submission.user.name, edit_accountability_log_submission_path(@submission.accountability_log, @submission)
      respond_with @submission
    else
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
  end

  def new
    @submission = Submission.new
    add_breadcrumb "New Submission", new_accountability_log_submission_path(@accountability_log)
    respond_to :html
  end

  def show
    @submission = Submission.find_by_accountability_log_id_and_id(params[:accountability_log_id], params[:id])
    if !@submission
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
    add_breadcrumb "Submission by " + @submission.user.name, accountability_log_submission_path(@submission.accountability_log, @submission)
    if session[:user_id].nil? or ((session[:user_id] != @submission.user.id) and !User.find_by_id(session[:user_id]).is_admin)
      head status: :forbidden and return
    end
    respond_with @submission
  end

  def create
    if session[:user_id].nil?
      head status: :forbidden and return
    end
    if !User.find_by_id(session[:user_id]).is_member
      head status: :forbidden and return
    end
    if Submission.find_by_accountability_log_id_and_user_id(params[:accountability_log_id], session[:user_id])
      head status: :conflict and return
    end
    submission = Submission.new(submission_parameters_create)
    if submission.save
      head status: :created
    else
      render json: {error: submission.errors}, status: :bad_request
    end
  end

  def destroy
    submission = Submission.find_by_accountability_log_id_and_id(params[:accountability_log_id], params[:id])
    if !submission
      head status: :not_found and return
    end
    if session[:user_id].nil? or (Submission.find_by_accountability_log_id_and_user_id(params[:accountability_log_id], session[:user_id]).nil? and !User.find_by_id(session[:user_id]).is_admin)
      head status: :forbidden and return
    end
    submission.destroy
    head status: :ok
  end

  private

  def submission_parameters_create
    parameters = params.require(:submission).permit(:binderstatus, :tasks, :goals)
    parameters[:accountability_log_id] = params[:accountability_log_id]
    parameters[:user_id] = session[:user_id]
    return parameters
  end
end
