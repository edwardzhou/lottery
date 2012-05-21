class Agent::AgentBaseController < ApplicationController
  before_filter :agent_required

  layout "admin"


  private
  def agent_required
    user = User.find(session[:user_id])
    redirect_to new_sessions_path if user.nil? or not user.is_agent?
  end

end
