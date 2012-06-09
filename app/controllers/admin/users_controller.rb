#encoding: utf-8

class Admin::UsersController < Admin::AdminBaseController

  before_filter :init

  include ApplicationHelper

  def index
    filter = params[:filter]
    filter = Regexp.new(filter, true) if filter
    @users = User.all
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
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    user_count = Sequence.next!("user_seq")
    user_count = user_count + 100 if user_count < 100
    username = format("y%03d", user_count)
    logger.debug("new agent username => " + username)
    @user = User.new(params[:user])
    @user.username = username
    @user.password = "888888"
    @user.password_confirmation = "888888"
    @user.odds_level = OddsLevel.find_by_level_id("level_a")
    @user.return = 0
    @user.available_credit = @user.total_credit
    @user.user_role = User::AGENT
    @user.agent = current_user
    @user.top_user = current_user

    if @user.save
      redirect_to( [:admin, @user], :notice => t("message.agent_created", :username => @user.username) )
    else
      render :action => "new"
    end
  end

  def show
    @user = User.find(params[:id])
    gon.page_json_url = bet_list_admin_user_path(@user, :format => "json")
  end

  #def edit
  #  @user = User.find(params[:id])
  #end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
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

  def bet_list
    @user = User.find(params[:id])
    if @user.is_agent?
      @bet_items = BetItem.bet_items_by_agent(@user, nil)
    elsif @user.is_admin?
      @bet_items = BetItem.bet_items_by_admin(@user, nil)
    else
      @bet_items = BetItem.bet_items_by_user(@user, nil)
    end
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

  private
  def init
    @odds_levels = OddsLevel.all
  end

end
