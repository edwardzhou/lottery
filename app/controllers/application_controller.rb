class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :log_uri
  before_filter :login_required

  def log_uri
    logger.debug("url => #{request.url}")
    logger.debug("request_uri => #{request.path}")
    gon.page_json_url = request.path + ".json"
  end

  def login_required
    redirect_to new_sessions_path if session[:user_id].nil?
  end


end
