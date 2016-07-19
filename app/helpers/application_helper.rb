module ApplicationHelper
  def logged_in
    session[:user_id] && User.find_by_id(session[:user_id])
  end

  def current_user
    session[:user_id] && User.find_by_id(session[:user_id])
  end
end
