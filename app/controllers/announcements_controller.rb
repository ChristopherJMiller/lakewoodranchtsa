class AnnouncementsController < ApplicationController
  respond_to :html, :json

  def index
    @announcements = Announcement.all
    respond_with @announcements
  end

  def show
    @announcement = Announcement.find_by_id(params[:id])
    if @announcement
      respond_with @announcement
    else
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
  end

  def new
    @announcement = Announcement.new
    respond_to :html
  end

  def edit
    @announcement = Announcement.find_by_id(params[:id])
    if @announcement
      respond_with @announcement
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
    announcement = Announcement.new(announcement_parameters_create)
    if announcement.save
      head status: :created, location: announcement_path(announcement)
    else
      render json: {error: announcement.errors}, status: :bad_request
    end
  end

  def update
    announcement = Announcement.find_by_id(params[:id])
    if !announcement
      head status: :not_found and return
    end
    if session[:user_id].nil? or !User.find_by_id(session[:user_id]).is_admin
      head status: :forbidden and return
    end
    if announcement.update(announcement_parameters_update)
      head status: :ok
    else
      render json: {error: announcement.errors}, status: :bad_request
    end
  end

  def destroy
    announcement = Announcement.find_by_id(params[:id])
    if !announcement
      head status: :not_found and return
    end
    if session[:user_id].nil? or !User.find_by_id(session[:user_id]).is_admin
      head status: :forbidden and return
    end
    announcement.destroy
    head status: :ok
  end

  private

  def announcement_parameters_update
    parameters = params.require(:announcement).permit(:title, :body)
  end

  def announcement_parameters_create
    parameters = params.require(:announcement).permit(:title, :body)
    parameters[:user] = User.find_by_id(session[:user_id])
    return parameters
  end

end
