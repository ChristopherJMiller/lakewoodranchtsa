# Controller for Announcements
class AnnouncementsController < ApplicationController
  respond_to :html, :json

  add_breadcrumb 'Announcements', :announcements_path

  def index
    @announcements = Announcement.all
    respond_with @announcements
  end

  def show
    @announcement = Announcement.find_by(id: params[:id])
    if @announcement
      add_breadcrumb @announcement.title, announcement_path(@announcement)
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
    add_breadcrumb 'New Announcement', new_announcement_path
    respond_to :html
  end

  def edit
    @announcement = Announcement.find_by(id: params[:id])
    if @announcement
      add_breadcrumb 'Edit ' + @announcement.title, edit_announcement_path(@announcement)
      respond_with @announcement
    else
      respond_to do |format|
        format.html { not_found }
        format.json { head status: :not_found }
      end
    end
  end

  def create
    return head status: :forbidden if session[:user_id].nil?
    return head status: :forbidden unless User.find_by(id: session[:user_id]).admin?
    announcement = Announcement.new(announcement_parameters_create)
    if announcement.save
      head status: :created, location: announcement_path(announcement)
    else
      render json: {error: announcement.errors}, status: :bad_request
    end
  end

  def update
    announcement = Announcement.find_by(id: params[:id])
    return head status: :not_found unless announcement
    if session[:user_id].nil? || !User.find_by(id: session[:user_id]).admin?
      return head status: :forbidden
    end
    if announcement.update(announcement_parameters_update)
      head status: :ok
    else
      render json: {error: announcement.errors}, status: :bad_request
    end
  end

  def destroy
    announcement = Announcement.find_by(id: params[:id])
    return head status: :not_found unless announcement
    if session[:user_id].nil? || !User.find_by(id: session[:user_id]).admin?
      return head status: :forbidden
    end
    announcement.destroy
    head status: :ok
  end

  private

  def announcement_parameters_update
    params.require(:announcement).permit(:title, :body)
  end

  def announcement_parameters_create
    parameters = params.require(:announcement).permit(:title, :body)
    parameters[:user] = User.find_by(id: session[:user_id])
    parameters
  end
end
