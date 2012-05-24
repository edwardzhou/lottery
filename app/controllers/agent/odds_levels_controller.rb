class Agent::OddsLevelsController < Agent::AgentBaseController

  def index
    @odds_level = OddsLevel.find(params[:id])
  end
end
