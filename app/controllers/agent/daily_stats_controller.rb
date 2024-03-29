class Agent::DailyStatsController < Agent::AgentBaseController

  include ApplicationHelper

  before_filter :init


  def index
    if request.xhr?
      @user_daily_stats = UserDailyStat.recent(current_user)
      @total_rows = @user_daily_stats.count
      rows_per_page = params[:rows] || 20
      @page = params[:page].to_i
      @pages = (@total_rows / rows_per_page.to_f).ceil

      @page = @pages if @page > @pages

      @user_daily_stats = @user_daily_stats.order_by(params[:sidx].to_sym => params[:sord]).paginate(:page => params[:page], :per_page => rows_per_page)
    end
  end


  def detail_stat
    if request.xhr?

      uds = UserDailyStat.find(params[:id])

      @user_daily_stats = UserDailyStat.by_agent(current_user).by_date(uds.stat_date)
      @total_rows = @user_daily_stats.count
      rows_per_page = params[:rows] || 20
      @page = params[:page].to_i
      @pages = (@total_rows / rows_per_page.to_f).ceil

      @page = @pages if @page > @pages

      @user_daily_stats = @user_daily_stats.order_by(params[:sidx].to_sym => params[:sord]).paginate(:page => params[:page], :per_page => rows_per_page)

    end
  end

  private
  def init
    gon.agent_daily_stats_path = agent_daily_stats_path
  end
end
