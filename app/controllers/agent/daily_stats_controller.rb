class Agent::DailyStatsController < Agent::AgentBaseController

  include ApplicationHelper

  def index
    if request.xhr?
      @user_daily_stats = UserDailyStat.recent(current_user)
      @total_rows = @user_daily_stats.count
      @page = 1
      @pages = 1
    end
  end


  def user_stat
    if request.xhr?
      @user_daily_stats = UserDailyStat.recent(current_user)
      @total_rows = @user_daily_stats.count
      @page = 1
      @pages = 1
    end
  end
end
