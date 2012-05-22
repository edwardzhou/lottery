class Agent::UsersController < Agent::AgentBaseController

  include ApplicationHelper

  def index

  end

  def new
    gon.ol_page_url = odds_level_info_agent_users_path
    @user = User.new
    @user.agent = current_user

  end

  def create

  end

  def odds_level_info
    odds_level_id = params[:id]
    @odds_level = OddsLevel.find(odds_level_id)
  end


end
