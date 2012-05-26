#encoding: utf-8

class Agent::UsersController < Agent::AgentBaseController

  include ApplicationHelper

  def index
    filter = params[:filter]
    filter = Regexp.new(filter, true) if filter
    @users = current_user.users
    @users = @users.where(:username => filter).or(:true_name => filter).or(:phone => filter) if filter
    @total_rows = @users.dup.count
    rows_per_page = params[:rows] || 20
    @page = params[:page].to_i
    @pages = (@total_rows / rows_per_page.to_f).ceil

    @page = @pages if @page > @pages

    if request.xhr?
      @users = @users.order_by(params[:sidx].to_sym => params[:sord]).paginate(:page => params[:page], :per_page => rows_per_page)
      #@users.paginate(:page => params[:page], :per_page => rows_per_page)
    end

  end

  def new
    gon.ol_page_url = agent_odds_levels_path
    @user = User.new
    @user.agent = current_user

  end

  def create
    user_params = params[:user]

    agent_user = current_user

    user_count = User.count
    logger.debug "user_count => " + user_count.to_s
    user_count = user_count + 100 if user_count < 100
    odds_level = OddsLevel.find(user_params[:odds_level_id])
    username = format("%s%03d", odds_level.level_code, user_count)
    logger.debug "allocated username => " + username


    if verify_params(user_params, agent_user, odds_level)
      user = User.new()
      user.username = username
      user.password = "666666"
      user.password_confirmation = "666666"
      user.true_name = user_params[:true_name]
      user.phone = user_params[:phone]
      user.total_credit = user_params[:total_credit]
      user.available_credit = user.total_credit
      user.odds_level = odds_level
      user.return = user_params[:return]
      user.user_role = User::USER
      user.agent = agent_user
      user.top_user = agent_user.top_user
      agent_user.available_credit = agent_user.available_credit - user.total_credit

      user.save!
      agent_user.save!

      redirect_to [:agent, user], :notice => t("message.user_created")

    else
      render :action => "new"
    end

  end

  def show
    @user = User.find(params[:id])
    gon.page_json_url = bet_list_agent_user_path(@user, :format => "json")
  end

  def bet_list
    @user = User.find(params[:id])
    @bet_items = BetItem.get_bet_items(@user, nil)
    @total_rows = @bet_items.count
    rows_per_page = params[:rows] || 20
    @page = params[:page].to_i
    @pages = (@total_rows / rows_per_page.to_f).ceil

    @page = @pages if @page > @pages

    if request.xhr?
      @bet_items = @bet_items.order_by(params[:sidx].to_sym => params[:sord]).paginate(:page => params[:page], :per_page => rows_per_page)
    end
    @user_data = {bet_rule_name: "合計", credit: 0.0, possible_win_credit: 0.0, total_return: 0.0 }
    @bet_items.each do |item|
      @user_data[:credit] = @user_data[:credit] + item.credit
      @user_data[:possible_win_credit] = @user_data[:possible_win_credit] + item.possible_win_credit
      @user_data[:total_return] = @user_data[:total_return] + item.total_return
    end

    render "home/bet_list"

  end


  def lock
    @user = User.find(params[:id])
    @user.lock_account!
    redirect_to :action => "index"
  end

  def unlock
    @user = User.find(params[:id])
    @user.unlock_account!
    redirect_to :action => "index"
  end

  private
  def verify_params(user_params, agent_user, odds_level, new_user = true)

    return false unless user_params[:return].to_d.between?(0, odds_level.return)

    agent_available_credit = agent_user.available_credit
    agent_available_credit = agent_available_credit + user_params[:total_credit].to_d unless new_user

    if user_params[:total_credit].to_d > agent_available_credit
      false
    else
      true
    end

  end


end
