class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :log_uri

  def log_uri
    logger.debug("url => #{request.url}")
    logger.debug("request_uri => #{request.path}")
    gon.page_json_url = request.path + ".json"
  end


end
