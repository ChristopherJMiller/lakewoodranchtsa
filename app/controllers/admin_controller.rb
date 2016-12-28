# Controller for Admin Control Panel
class AdminController < ApplicationController
  respond_to :html
  before_action :check_if_admin

  add_breadcrumb 'Admin Dasboard', :admin_dashboard_path

  def check_if_admin
    return head status: :forbidden unless logged_in
    return head status: :forbidden unless current_user.admin?
  end

  def teams
    @teams = Team.all
    add_breadcrumb 'All Teams', :admin_teams_path
    respond_with @teams
  end

  def attendance
    if params[:commit] == 'Search'
      @sign_up_count = SignUpSheet.where(created_at: params[:search][:from].to_date..params[:search][:to].to_date).size
    else
      @sign_up_count = SignUpSheet.all.count
    end
    @users = User.all
    add_breadcrumb 'Attendance Report', :admin_attendance_path
    respond_with @users
  end
end
