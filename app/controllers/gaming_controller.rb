#encoding: utf-8

class GamingController < ApplicationController

  include ApplicationHelper

  before_filter :init

  BALL_NAMES = %w(none 第一球 第二球 第三球 第四球 第五球 第六球 第七球 第八球)
  HALF_BET_ITEMS = {:big => "大", :small => "小", :even => "雙",
                    :odd => "單", :trail_big => "尾大", :trail_small => "尾小",
                    :sum_even => "合數雙", :sum_odd => "合數單"}
  QUARTER_BET_ITEMS = {:east => "東", :south => "南", :west => "西", :north => "北"}
  THIRD_BET_ITEMS = {:middle => "中", :fa => "發", :white => "白"}

  #helper_method

  def index
    redirect_to :action => "show", :id => "ball9"
  end

  def show
    @id = params[:id]
    ball_id = 0
    ball_regex = /^ball(\d\d?)$/
    if @id =~ ball_regex then
      ball_id = ball_regex.match(@id)[1].to_i
    end

    if ball_id == 0
      render :action => "index"
    elsif ball_id
      @ball = current_lottery.balls[ball_id - 1]
    end

    gon.ball_url = gaming_path(@id, format: :json)

    if ball_id > 8 and not request.xhr?
      render "ball9"
    end
  end

  def update
    @id = params[:id]
    bet_params = params[@id]

    ball_id = 0
    ball_regex = /^ball(\d\d?)$/
    if @id =~ ball_regex then
      ball_id = ball_regex.match(@id)[1].to_i
    end

    if not ball_id.between?(1, 11) or bet_params.nil? then
      redirect_to :action => "show", :id => "ball9", :alert => "无效投注"
    elsif ball_id.between?(1, 8) #1至8球
      handle_ball_bet(ball_id, bet_params)
    elsif ball_id == 9 #两面盘
      handle_sum_bet(ball_id, bet_params)
    elsif ball_id == 10 #总和、龙虎
      handle_dl_bet(ball_id, bet_params)
    end

    redirect_to :action => "show", :id => @id

  end


  private

  def handle_ball_bet(ball_id, bet_params)
    today_stat = UserDailyStat.get_current_stat(@current_user)

    bet_items = []
    (1..20).each do |ball_index|
      bet_credit = bet_params["ball_#{ball_index}"].to_i
      if bet_credit > 0
        bet_item = BetItem.new
        bet_item.user = @current_user
        bet_item.user_daily_stat = today_stat
        bet_item.lottery_inst = current_lottery
        bet_item.bet_rule_name = get_bet_rule_name(ball_id, ball_index)
        bet_item.bet_rule_eval = "ball_#{ball_id}.ball_value == #{ball_index}"
        bet_item.credit = bet_credit
        bet_item.return = @odds_level.return
        bet_item.total_return = (bet_item.credit * bet_item.return).to_i
        bet_item.odds = @odds_level.rule_by_name("exact").odds
        bet_item.possible_win_credit = (bet_item.credit * bet_item.odds).to_i
        #bet_item.save!
        bet_items << bet_item
      end
    end

    HALF_BET_ITEMS.each do |item, item_name|
      bet_credit = bet_params[item].to_i
      if bet_credit > 0
        bet_item = BetItem.new
        bet_item.user = @current_user
        bet_item.user_daily_stat = today_stat
        bet_item.lottery_inst = current_lottery
        bet_item.bet_rule_name = BALL_NAMES[ball_id] + " 出 " + item_name
        bet_item.bet_rule_eval = "ball_#{ball_id}.#{item}"
        bet_item.credit = bet_credit
        bet_item.return = @odds_level.return
        bet_item.total_return = (bet_item.credit * bet_item.return).to_i
        bet_item.odds = @odds_level.rule_by_name("half").odds
        bet_item.possible_win_credit = (bet_item.credit * bet_item.odds).to_i
        #bet_item.save!
        bet_items << bet_item
      end
    end

    QUARTER_BET_ITEMS.each do |item, item_name|
      bet_credit = bet_params[item].to_i
      if bet_credit > 0
        bet_item = BetItem.new
        bet_item.user = @current_user
        bet_item.user_daily_stat = today_stat
        bet_item.lottery_inst = current_lottery
        bet_item.bet_rule_name = BALL_NAMES[ball_id] + " 出 " + item_name
        bet_item.bet_rule_eval = "ball_#{ball_id}.#{item}"
        bet_item.credit = bet_credit
        bet_item.return = @odds_level.return
        bet_item.total_return = (bet_item.credit * bet_item.return).to_i
        bet_item.odds = @odds_level.rule_by_name("quarter").odds
        bet_item.possible_win_credit = (bet_item.credit * bet_item.odds).to_i
        #bet_item.save!
        bet_items << bet_item
      end
    end

    THIRD_BET_ITEMS.each do |item, item_name|
      bet_credit = bet_params[item].to_i
      if bet_credit > 0
        bet_item = BetItem.new
        bet_item.user = @current_user
        bet_item.user_daily_stat = today_stat
        bet_item.lottery_inst = current_lottery
        bet_item.bet_rule_name = BALL_NAMES[ball_id] + " 出 " + item_name
        bet_item.bet_rule_eval = "ball_#{ball_id}.#{item}"
        bet_item.credit = bet_credit
        bet_item.return = @odds_level.return
        bet_item.total_return = (bet_item.credit * bet_item.return).to_i
        bet_item.odds = @odds_level.rule_by_name("third").odds
        bet_item.possible_win_credit = (bet_item.credit * bet_item.odds).to_i
        #bet_item.save!
        bet_items << bet_item
      end
    end

    bet_items.each {|item| item.save!}

    total_bet_credit = bet_items.inject(0) { |sum, item| sum + item.credit }
    @current_user.available_credit = @current_user.available_credit - total_bet_credit
    @current_user.save!

  end

  def handle_sum_bet(ball_id, bet_params)

  end

  def handle_dl_bet(ball_id, bet_params)

  end

  def get_bet_rule_name(ball_id, ball_no)
    BALL_NAMES[ball_id] + " 出 " + ball_no.to_s
  end





  def init
    gon.total_credit = current_user.total_credit
    gon.available_credit = current_user.available_credit
    @lottery = current_lottery
    @previous_lottery = previous_lottery

    @odds_level = @lottery.get_odds_level(current_user.odds_level.level_id)


    @sum_bet_odd_even_rules = []
    @sum_bet_odd_even_rules << Rule.new({:rule_name => "sum[odd]", :rule_title => "總和單", :odds => "1.984"})
    @sum_bet_odd_even_rules << Rule.new({:rule_name => "sum[even]", :rule_title => "總和雙", :odds => "1.984"})

    @sum_bet_big_small_rules = []
    @sum_bet_big_small_rules << Rule.new({:rule_name => "sum[big]", :rule_title => "總和大", :odds => "1.984"})
    @sum_bet_big_small_rules << Rule.new({:rule_name => "sum[small]", :rule_title => "總和小", :odds => "1.984"})

    @sum_bet_trail_big_small_rules = []
    @sum_bet_trail_big_small_rules << Rule.new({:rule_name => "sum[trail_big]", :rule_title => "總和尾大", :odds => "1.984"})
    @sum_bet_trail_big_small_rules << Rule.new({:rule_name => "sum[trail_small]", :rule_title => "總和尾小", :odds => "1.984"})

    @sum_bet_dt_rules = []
    @sum_bet_dt_rules << Rule.new({:rule_name => "sum[dragon]", :rule_title => "龍", :odds => "1.984"})
    @sum_bet_dt_rules << Rule.new({:rule_name => "sum[tiger]", :rule_title => "虎", :odds => "1.984"})

    @sum_ball_rules = []
    @sum_ball_rules << Rule.new({:rule_name => "big", :rule_title => "大", :odds => "1.984"})
    @sum_ball_rules << Rule.new({:rule_name => "small", :rule_title => "小", :odds => "1.984"})
    @sum_ball_rules << Rule.new({:rule_name => "odd", :rule_title => "單", :odds => "1.984"})
    @sum_ball_rules << Rule.new({:rule_name => "even", :rule_title => "雙", :odds => "1.984"})
    @sum_ball_rules << Rule.new({:rule_name => "trail_big", :rule_title => "尾大", :odds => "1.984"})
    @sum_ball_rules << Rule.new({:rule_name => "trail_small", :rule_title => "尾小", :odds => "1.984"})
    @sum_ball_rules << Rule.new({:rule_name => "add_odd", :rule_title => "合數單", :odds => "1.984"})
    @sum_ball_rules << Rule.new({:rule_name => "add_even", :rule_title => "合數雙", :odds => "1.984"})

    @sum_balls_1 = []
    ball_index = 1
    %w(第一球 第二球 第三球 第四球).each do |ball_name|
      @sum_balls_1 << {:ball_name => ball_name, :ball_no => ball_index, :ball_rules => @sum_ball_rules}
      ball_index = ball_index.next
    end

    @sum_balls_2 = []
    %w(第五球 第六球 第七球 第八球).each do |ball_name|
      @sum_balls_2 << {:ball_name => ball_name, :ball_no => ball_index, :ball_rules => @sum_ball_rules}
      ball_index = ball_index.next
    end

    @ball_rules = []
    @ball_rules << Rule.new({:rule_name => "ball_big", :rule_title => "大"})
    @ball_rules << Rule.new({:rule_name => "ball_small", :rule_title => "小"})
    @ball_rules << Rule.new({:rule_name => "ball_odd", :rule_title => "單"})
    @ball_rules << Rule.new({:rule_name => "ball_even", :rule_title => "雙"})
    @ball_rules << Rule.new({:rule_name => "ball_trail_big", :rule_title => "尾大"})
    @ball_rules << Rule.new({:rule_name => "ball_trail_small", :rule_title => "尾小"})
    @ball_rules << Rule.new({:rule_name => "ball_add_odd", :rule_title => "合數單"})
    @ball_rules << Rule.new({:rule_name => "ball_add_even", :rule_title => "合數雙"})
    @single_ball_rule = Rule.new({:rule_name => "bet", :rule_title => "", :odds => "1.96"})


  end


end
