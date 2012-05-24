class Agent::AgentBaseController < ApplicationController
  before_filter :user_required

  private
  def user_required
    user = User.find(session[:user_id])
    redirect_to new_sessions_path if user.nil? or not user.is_user?
  end

end
