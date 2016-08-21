class TeamMembersController < ApplicationController
  respond_to :html, :json

  def index
    @team_members = Team.find_by_id(params[:team_id]).team_members.all
    respond_with @team_members
  end

  def create
    if session[:user_id].nil? or params[:team_member][:user_id] != session[:user_id].to_s
      head status: :forbidden and return
    end
    if !User.find_by_id(session[:user_id]).is_member or Team.find_by_id(params[:team_id]).full
      head status: :forbidden and return
    end
    if TeamMember.find_by_team_id_and_user_id(params[:team_id], params[:team_member][:user_id])
      head status: :conflict and return
    end
    team_member = TeamMember.new(team_member_parameters_create)
    if team_member.save
      head status: :created, location: event_team_team_member_path(team_member.team.event, team_member.team, team_member)
    else
      render json: {error: team_member.errors}, status: :bad_request
    end
  end

  def destroy
    team_member = TeamMember.find_by_team_id_and_id(params[:team_id], params[:id])
    if !team_member
      head status: :not_found and return
    end
    if session[:user_id].nil? or (TeamMember.find_by_team_id_and_user_id(params[:team_id], session[:user_id]).nil? and !User.find_by_id(session[:user_id]).is_admin) or (!User.find_by_id(session[:user_id]).is_admin and !TeamMember.find_by_team_id_and_user_id(params[:team_id], session[:user_id]).user.is_member)
      head status: :forbidden and return
    end
    team_member.destroy
    head status: :ok
  end

  private

  def team_member_parameters_create
    parameters = params.require(:team_member).permit(:user_id)
    parameters[:team_id] = params[:team_id]
    return parameters
  end
end