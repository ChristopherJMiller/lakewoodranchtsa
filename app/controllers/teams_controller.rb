# Controller for teams of a certain event
class TeamsController < ApplicationController
  respond_to :html, :json
  before_action :define_breadcrumb

  def define_breadcrumb
    add_breadcrumb 'Events', :events_path
    @event = Event.find_by(id: params[:event_id])
    add_breadcrumb @event.name, event_path(@event)
    add_breadcrumb 'Teams', event_teams_path(@event)
  end

  def index
    @teams = Event.find_by(id: params[:event_id]).teams.all
    respond_with @teams
  end

  def show
    @team = Team.find_by(id: params[:id])
    if @team
      add_breadcrumb @team.name, event_team_path(@team.event, @team)
      respond_with @team
    else
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
  end

  def new
    @team = Team.new
    add_breadcrumb 'New Team', new_event_team_path(@event)
    respond_to :html
  end

  def edit
    @team = Team.find_by(id: params[:id])
    if @team
      add_breadcrumb 'Edit' + @team.name, edit_event_team_path(@team.event, @team)
      respond_with @team
    else
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
  end

  def create
    if session[:user_id].nil? || !User.find_by(id: session[:user_id]).admin?
      return head status: :forbidden
    end
    team = Team.new(team_parameters_create)
    if team.save
      TeamMember.create(team_id: team.id, user_id: session[:user_id])
      head status: :created, location: event_team_path(team.event, team)
    else
      render json: {error: team.errors}, status: :bad_request
    end
  end

  def update
    team = Team.find_by(id: params[:id])
    return head status: :not_found unless team
    if session[:user_id].nil? || (TeamMember.find_by(team_id: params[:team_id], id: params[:user_id]).nil? && !User.find_by(id: session[:user_id]).admin?)
      return head status: :forbidden
    end
    if team.update(team_parameters_update)
      head status: :ok
    else
      render json: {error: team.errors}, status: :bad_request
    end
  end

  def destroy
    team = Team.find_by(id: params[:id])
    return head status: :not_found unless team
    if session[:user_id].nil? || !User.find_by(id: session[:user_id]).admin?
      return head status: :forbidden
    end
    Team.destroy(team.id)
    head status: :ok
  end

  private

  def team_parameters_create
    parameters = params.require(:team).permit(:name)
    parameters[:event_id] = params[:event_id]
    parameters[:closed] = false
    parameters
  end

  def team_parameters_update
    parameters = params.require(:team).permit(:name, :closed)
    parameters
  end
end
