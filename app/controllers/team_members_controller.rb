# Routes for Members of a Team
class TeamMembersController < ApplicationController
  respond_to :html, :json
  before_action :define_breadcrumb, except: [:create, :update, :destroy]

  def index
    @team_members = Team.find_by(id: params[:team_id]).team_members.all
    respond_with @team_members
  end

  def edit
    @team_member = TeamMember.find_by(team_id: params[:team_id], id: params[:id])
    if @team_member
      add_breadcrumb 'Edit ' + @team_member.user.name, edit_event_team_team_member_path(@team_path.event, @team_path, @team_member)
      respond_with @team_member
    else
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
  end

  def new
    @team_member = TeamMember.new
    add_breadcrumb 'New Team Member', new_event_team_team_member_path(@team_path.event, @team_path)
    respond_to :html
  end

  def create
    return head status: :forbidden if session[:user_id].nil?
    if !User.find_by(id: session[:user_id]).admin? || Team.find_by(id: params[:team_id]).full
      return head status: :forbidden
    end
    if TeamMember.find_by(team_id: params[:team_id], user_id: params[:team_member][:user_id])
      return head status: :conflict
    end
    team_member = TeamMember.new(team_member_parameters_create)
    if team_member.save
      head status: :created, location: event_team_team_member_path(team_member.team.event, team_member.team, team_member)
    else
      render json: {error: team_member.errors}, status: :bad_request
    end
  end

  def update
    team_member = TeamMember.find_by(team_id: params[:team_id], id: params[:id])
    return head status: :not_found unless team_member
    if session[:user_id].nil? || (TeamMember.find_by(team_id: params[:team_id], user_id: session[:user_id]).nil? && !User.find_by(id: session[:user_id]).admin?) || ((!TeamMember.find_by(team_id: params[:team_id], user_id: session[:user_id]).nil? && !TeamMember.find_by(team_id: params[:team_id], user_id: session[:user_id]).admin) && !User.find_by(id: session[:user_id]).admin?)
      return head status: :forbidden
    end
    if team_member.update(team_member_parameters_update)
      head status: :ok
    else
      render json: {error: team_member.errors}, status: :bad_request
    end
  end

  def destroy
    team_member = TeamMember.find_by(team_id: params[:team_id], id: params[:id])
    return head status: :not_found unless team_member
    if session[:user_id].nil? || (TeamMember.find_by(team_id: params[:team_id], user_id: session[:user_id]).nil? && !User.find_by(id: session[:user_id]).admin?) || (!User.find_by(id: session[:user_id]).admin? && !TeamMember.find_by(team_id: params[:team_id], user_id: session[:user_id]).user.member?)
      return head status: :forbidden
    end
    team_member.destroy
    head status: :ok
  end

  private

  def team_member_parameters_create
    parameters = params.require(:team_member).permit(:user_id, :admin)
    parameters[:team_id] = params[:team_id]
    parameters
  end

  def team_member_parameters_update
    parameters = params.require(:team_member).permit(:admin)
    parameters
  end

  def define_breadcrumb
    @team_path = Team.find_by(event_id: params[:event_id], id: params[:team_id])
    add_breadcrumb 'Events', :events_path
    add_breadcrumb @team_path.event.name, event_path(@team_path.event)
    add_breadcrumb 'Teams', event_teams_path(@team_path.event)
    add_breadcrumb @team_path.name, event_teams_path(@team_path.event)
    add_breadcrumb 'Team Members', event_team_team_members_path(@team_path.event, @team_path)
  end
end
