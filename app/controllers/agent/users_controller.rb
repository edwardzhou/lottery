class Agent::UsersController < Agent::AgentBaseController

  include ApplicationHelper

  def index

  end

  def new
    gon.ol_page_url = agent_odds_levels_path
    @user = User.new
    @user.agent = current_user

  end

  def create

  end

end
