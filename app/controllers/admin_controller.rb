class AdminController < ApplicationController
  respond_to :html
  before_filter :check_if_admin

  add_breadcrumb "Admin Dasboard", :admin_dashboard_path

  def check_if_admin
    if !logged_in
      head status: :forbidden and return
    end

    if !current_user.is_admin
      head status: :forbidden and return
    end
  end

  def teams
    @teams = Team.all
    add_breadcrumb "All Teams", :admin_teams_path
    respond_with @teams
  end
end
