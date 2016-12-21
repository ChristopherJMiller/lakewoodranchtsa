# Attendee Controller
class AttendeesController < ApplicationController
  respond_to :html, :json
  before_action :define_breadcrumb

  def define_breadcrumb
    add_breadcrumb 'Sign Up Sheets', :sign_up_sheets_path
    @sign_up_sheet = SignUpSheet.find_by(id: params[:sign_up_sheet_id])
    add_breadcrumb @sign_up_sheet.name, sign_up_sheet_path(@sign_up_sheet)
  end

  def index
    @attendees = SignUpSheet.find_by(id: params[:sign_up_sheet_id]).attendees.all
    respond_with @attendees
  end

  def create
    return head status: :forbidden if session[:user_id].nil?
    return head status: :forbidden unless User.find_by(id: session[:user_id]).admin?
    if Attendee.find_by(sign_up_sheet_id: params[:sign_up_sheet_id], user_id: params[:attendee][:user_id])
      return head status: :conflict
    end
    attendee = Attendee.new(attendee_parameters_create)
    if attendee.save
      head status: :created, location: sign_up_sheet_attendee_path(attendee.sign_up_sheet, attendee)
    else
      render json: {error: attendee.errors}, status: :bad_request
    end
  end

  def destroy
    attendee = Attendee.find_by(sign_up_sheet_id: params[:sign_up_sheet_id], id: params[:id])
    return head status: :not_found unless attendee
    if session[:user_id].nil? || (Attendee.find_by(sign_up_sheet_id: params[:sign_up_sheet_id], user_id: session[:user_id]).nil? && !User.find_by(id: session[:user_id]).admin?) || (!User.find_by(id: session[:user_id]).admin? && !Attendee.find_by(sign_up_sheet_id: params[:sign_up_sheet_id], user_id: session[:user_id]).user.member?)
      return head status: :forbidden
    end
    attendee.destroy
    head status: :ok
  end

  private

  def attendee_parameters_create
    parameters = params.require(:attendee).permit(:user_id)
    parameters[:sign_up_sheet_id] = params[:sign_up_sheet_id]
    parameters
  end
end
