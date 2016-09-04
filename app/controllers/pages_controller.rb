class PagesController < ApplicationController
  respond_to :html

  def dashboard
    if !logged_in
      head status: :forbidden and return
    end

    if !current_user.is_admin
      head status: :forbidden and return
    end

    respond_to :html
  end
end
