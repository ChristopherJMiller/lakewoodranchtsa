# Base controller for Application
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_start_time

  add_breadcrumb 'Home', :root_path

  def set_start_time
    @start_time = Time.now.to_f
  end

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  def logged_in
    session[:user_id] && User.find_by(id: session[:user_id])
  end

  def current_user
    session[:user_id] && User.find_by(id: session[:user_id])
  end
end
