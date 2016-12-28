# Routes for Accountability Log Submissions
class SubmissionsController < ApplicationController
  respond_to :html, :json
  before_action :define_breadcrumb

  def define_breadcrumb
    add_breadcrumb 'Accountability Logs', :accountability_logs_path
    @accountability_log = AccountabilityLog.find_by(id: params[:accountability_log_id])
    add_breadcrumb 'Accountability Log #' + @accountability_log.id.to_s, accountability_log_path(@accountability_log)
    add_breadcrumb 'Submissions', accountability_log_path(@accountability_log)
  end

  def index
    if session[:user_id].nil? || !User.find_by(id: session[:user_id]).admin?
      return head status: :forbidden
    end
    @submissions = AccountabilityLog.find_by(id: params[:accountability_log_id]).submissions
    respond_with @submissions
  end

  def edit
    @submission = Submission.find_by(accountability_log_id: params[:accountability_log_id], id: params[:id])
    if @submission
      add_breadcrumb 'Edit Submission by ' + @submission.user.name, edit_accountability_log_submission_path(@submission.accountability_log, @submission)
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
    add_breadcrumb 'New Submission', new_accountability_log_submission_path(@accountability_log)
    respond_to :html
  end

  def show
    @submission = Submission.find_by(accountability_log_id: params[:accountability_log_id], id: params[:id])
    unless @submission
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
    add_breadcrumb 'Submission by ' + @submission.user.name, accountability_log_submission_path(@submission.accountability_log, @submission)
    if session[:user_id].nil? || ((session[:user_id] != @submission.user.id) && !User.find_by(id: session[:user_id]).admin?)
      return head status: :forbidden
    end
    respond_with @submission
  end

  def create
    return head status: :forbidden if session[:user_id].nil?
    return head status: :forbidden unless User.find_by(id: session[:user_id]).member?

    # Checks for duplicate submission
    return head status: :conflict if Submission.find_by(accountability_log_id: params[:accountability_log_id], user_id: session[:user_id])

    submission = Submission.new(submission_parameters_create)
    if submission.save
      head status: :created
    else
      render json: {error: submission.errors}, status: :bad_request
    end
  end

  def destroy
    submission = Submission.find_by(accountability_log_id: params[:accountability_log_id], id: params[:id])
    return head status: :not_found unless submission
    if session[:user_id].nil? || (Submission.find_by(accountability_log_id: params[:accountability_log_id], user_id: session[:user_id]).nil? && !User.find_by(id: session[:user_id]).admin?)
      return head status: :forbidden
    end
    submission.destroy
    head status: :ok
  end

  private

  def submission_parameters_create
    parameters = params.require(:submission).permit(:binderstatus, :tasks, :goals)
    parameters[:accountability_log_id] = params[:accountability_log_id]
    parameters[:user_id] = session[:user_id]
    parameters
  end
end
