class AttendeesController < ApplicationController
  respond_to :html, :json

  def index
    @attendees = SignUpSheet.find_by_id(params[:sign_up_sheet_id]).attendees.all
    respond_with @attendees
  end

  def create
    if session[:user_id].nil? or params[:attendee][:user_id] != session[:user_id].to_s
      head status: :forbidden and return
    end
    if !User.find_by_id(session[:user_id]).is_member
      head status: :forbidden and return
    end
    if Attendee.find_by_sign_up_sheet_id_and_user_id(params[:sign_up_sheet_id], params[:attendee][:user_id])
      head status: :conflict and return
    end
    attendee = Attendee.new(attendee_parameters_create)
    if attendee.save
      head status: :created, location: sign_up_sheet_attendee_path(attendee.sign_up_sheet, attendee)
    else
      render json: {error: attendee.errors}, status: :bad_request
    end
  end

  def destroy
    attendee = Attendee.find_by_sign_up_sheet_id_and_id(params[:sign_up_sheet_id], params[:id])
    if !attendee
      head status: :not_found and return
    end
    if session[:user_id].nil? or (Attendee.find_by_sign_up_sheet_id_and_user_id(params[:sign_up_sheet_id], session[:user_id]).nil? and !User.find_by_id(session[:user_id]).is_admin) or (!User.find_by_id(session[:user_id]).is_admin and !Attendee.find_by_sign_up_sheet_id_and_user_id(params[:sign_up_sheet_id], session[:user_id]).user.is_member)
      head status: :forbidden and return
    end
    attendee.destroy
    head status: :ok
  end

  private

  def attendee_parameters_create
    parameters = params.require(:attendee).permit(:user_id)
    parameters[:sign_up_sheet_id] = params[:sign_up_sheet_id]
    return parameters
  end
end
