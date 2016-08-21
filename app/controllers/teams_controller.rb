class TeamsController < ApplicationController
  respond_to :html, :json

  def index
    @teams = Event.find_by_id(params[:event_id]).teams.all
    respond_with @teams
  end

  def show
    @team = Team.find_by_id(params[:id])
    if @team
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
    respond_to :html
  end

  def edit
    @team = Team.find_by_id(params[:id])
    if @team
      respond_with @team
    else
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
  end

  def create
    if session[:user_id].nil? or !User.find_by_id(session[:user_id]).is_member
      head status: :forbidden and return
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
    team = Team.find_by_id(params[:id])
    if !team
      head status: :not_found and return
    end
    if session[:user_id].nil? or (TeamMember.find_by_team_id_and_user_id(params[:team_id], params[:user_id]).nil? and !User.find_by_id(session[:user_id]).is_admin)
      head status: :forbidden and return
    end
    if team.update(team_parameters_update)
      head status: :ok
    else
      render json: {error: team.errors}, status: :bad_request
    end
  end

  def destroy
    team = Team.find_by_id(params[:id])
    if !team
      head status: :not_found and return
    end
    if session[:user_id].nil? or !User.find_by_id(session[:user_id]).is_admin
      head status: :forbidden and return
    end
    Team.destroy(team.id)
    head status: :ok
  end

  private

  def team_parameters_create
    parameters = params.require(:team).permit(:name)
    parameters[:event_id] = params[:event_id]
    parameters[:closed] = false
    return parameters
  end

  def team_parameters_update
    parameters = params.require(:team).permit(:name, :closed)
    return parameters
  end
end
