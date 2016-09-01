class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def logged_in
    session[:user_id] && User.find_by_id(session[:user_id])
  end

  def current_user
    session[:user_id] && User.find_by_id(session[:user_id])
  end
end
