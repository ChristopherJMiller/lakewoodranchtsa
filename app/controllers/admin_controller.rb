class AdminController < ApplicationController
  respond_to :html
  before_filter :check_if_admin

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
    respond_with @teams
  end
end
