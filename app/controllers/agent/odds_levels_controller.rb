class Agent::OddsLevelsController < Agent::AgentBaseController

  def show
    @odds_level = OddsLevel.find(params[:id])
  end
end
