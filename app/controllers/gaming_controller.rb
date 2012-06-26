#encoding: utf-8

require "lottery_rule_names"

class GamingController < UserBaseController

  include ApplicationHelper
  include LotteryRuleNames


  before_filter :init


  #helper_method

  def index
    redirect_to :action => "show", :id => "ball9"
  end

  def show
    @id = params[:id]
    @ball_id = 0
    ball_regex = /^ball(\d\d?)$/
    if @id =~ ball_regex then
      @ball_id = ball_regex.match(@id)[1].to_i
    end

    if @ball_id == 0
      render :action => "index"
    elsif @ball_id
      @ball = current_lottery.balls[@ball_id - 1]
    end

    gon.ball_url = gaming_path(@id, format: :json)
    gon.ball_analyst_url = analyst_gaming_path(@id, format: :js)
    gon.ball_9_analyst_url = analyst_gaming_path("ball9", format: :js)

    @ball_apprs = LotteryAnalyst.by_group("ball_#{@ball_id}_appr")
    @ball_no_apprs = LotteryAnalyst.by_group("no_no_appr")
    @ball_name = BALL_NAMES[@ball_id]

    if @ball_id > 8 and not request.xhr?
      render "ball#{@ball_id}"
    end
  end

  def update
    @id = params[:id]
    bet_params = params[@id]

    @ball_id = 0
    ball_regex = /^ball(\d\d?)$/
    if @id =~ ball_regex then
      @ball_id = ball_regex.match(@id)[1].to_i
    end

    if not @ball_id.between?(1, 11) or bet_params.nil?
      @ball_id = 0
      redirect_to :action => "show", :id => "ball9", :alert => "无效投注"
    end

    if @lottery.accept_betting
      if @ball_id.between?(1, 8) #1至8球
        handle_ball_bet(@ball_id, bet_params)
      elsif @ball_id == 9 #两面盘
        handle_sum_bet(@ball_id, bet_params)
      elsif @ball_id == 10 #总和、龙虎
        handle_sum_bet(@ball_id, bet_params)
      elsif @ball_id == 11 #连码
        handle_cp_bet(@ball_id, bet_params)
      end

      redirect_to :action => "show", :id => @id
    else
      redirect_to :action => "show", :id => @id, :alert => "投注失败，已关闭投注！"
    end

  end

  def analyst
    @id = params[:id]
    @group = params[:g]
    @ball_id = 0
    ball_regex = /^ball(\d\d?)$/
    if @id =~ ball_regex then
      @ball_id = ball_regex.match(@id)[1].to_i
    end

    @ball_id = 9 if (@ball_id == 0) or (@ball_id > 10)

    analyst_id = "ball_#{@ball_id}_#{@group}"

    logger.debug("analyst_id => #{analyst_id}")

    @analyst = LotteryAnalyst.get_by_id(analyst_id, false)
    @item_holder = "sum_analyst"

    #@analyst =  if @analyst.nil?
    @ball_name = BALL_NAMES[@ball_id]

    if @ball_id > 8
      partial_item = "a_ball_9_#{@group}"
      if @group == "sum"
        @analyst = LotteryAnalyst.by_sum(10)
      else
        @item_holder = params["ball"].blank? ? "sum_detail" : "ball_detail"
        partial_item = "a_ball_seq"
      end

    else

      if @group != "ball_sum"
        @item_holder = "ball_detail"
        partial_item = "a_ball_seq"
      else
        @ball_apprs = LotteryAnalyst.by_group("ball_#{@ball_id}_appr")
        @ball_no_apprs = LotteryAnalyst.by_group("no_no_appr")
        render :partial => "a_ball_sum_info", :locals => {:analyst => @analyst,
                                                  :ball_id => @ball_id,
                                                  #:item_name => partial_item,
                                                  :ball_apprs => @ball_apprs,
                                                  :ball_no_apprs => @ball_no_apprs,
                                                  :ball_name => @ball_name,}
        return
      end
    end

    render :partial => "analyst", :locals => {:item_holder => @item_holder,
                                              :analyst => @analyst,
                                              :ball_id => @ball_id,
                                              :item_name => partial_item,
                                              :ball_apprs => @ball_apprs,
                                              :ball_no_apprs => @ball_no_aprs,
                                              :ball_name => @ball_name,}

  end


  private

  def handle_ball_bet(ball_id, bet_params)
    today_stat = UserDailyStat.get_current_stat(@current_user, @lottery.lottery_date)

    bet_items = []
    (1..20).each do |ball_index|
      bet_credit = bet_params["ball_#{ball_index}"].to_i
      if bet_credit > 0
        rule_id = "ball_#{ball_id}_#{ball_index}"
        rule_name = BALL_NAMES[ball_id] + " 開 " + format("%02d", ball_index)
        rule_eval = "ball_#{ball_id}.ball_value == #{ball_index}"
        logger.info("new bet_item[rule_id: #{rule_id}, rule_name: #{rule_name}, rule_eval: #{rule_eval}]")
        bet_item = new_bet_item(ball_id, bet_credit, today_stat, "exact", rule_id, rule_name, rule_eval)
        bet_rule = @lottery.bet_rule(rule_id)
        bet_rule.bet_count = bet_rule.bet_count + 1
        bet_rule.total_income = bet_rule.total_income.to_f + bet_credit
        bet_rule.total_outcome = bet_rule.total_outcome.to_f + bet_item.possible_win_credit
        #bet_item.save!
        bet_items << bet_item
      end
    end

    HALF_BET_ITEMS.each do |item, item_name|
      bet_credit = bet_params[item].to_i
      if bet_credit > 0
        rule_id = "ball_#{ball_id}_#{item}"
        rule_name = BALL_NAMES[ball_id] + " 開 " + item_name
        rule_eval = "ball_#{ball_id}.#{item}"
        logger.info("new bet_item[rule_id: #{rule_id}, rule_name: #{rule_name}, rule_eval: #{rule_eval}]")
        bet_item = new_bet_item(ball_id, bet_credit, today_stat, "half", rule_id, rule_name, rule_eval)
        bet_rule = @lottery.bet_rule(rule_id)
        bet_rule.bet_count = bet_rule.bet_count + 1
        bet_rule.total_income = bet_rule.total_income.to_f + bet_credit
        bet_rule.total_outcome = bet_rule.total_outcome.to_f + bet_item.possible_win_credit
        #bet_item.save!
        bet_items << bet_item
      end
    end

    QUARTER_BET_ITEMS.each do |item, item_name|
      bet_credit = bet_params[item].to_i
      if bet_credit > 0
        rule_id = "ball_#{ball_id}_#{item}"
        rule_name = BALL_NAMES[ball_id] + " 開 " + item_name
        rule_eval = "ball_#{ball_id}.#{item}"
        logger.info("new bet_item[rule_id: #{rule_id}, rule_name: #{rule_name}, rule_eval: #{rule_eval}]")
        bet_item = new_bet_item(ball_id, bet_credit, today_stat, "quarter", rule_id, rule_name, rule_eval)
        bet_rule = @lottery.bet_rule(rule_id)
        bet_rule.bet_count = bet_rule.bet_count + 1
        bet_rule.total_income = bet_rule.total_income.to_f + bet_credit
        bet_rule.total_outcome = bet_rule.total_outcome.to_f + bet_item.possible_win_credit
        #bet_item.save!
        bet_items << bet_item
      end
    end

    THIRD_BET_ITEMS.each do |item, item_name|
      bet_credit = bet_params[item].to_i
      if bet_credit > 0
        rule_id = "ball_#{ball_id}_#{item}"
        rule_name = BALL_NAMES[ball_id] + " 開 " + item_name
        rule_eval = "ball_#{ball_id}.#{item}"
        logger.info("new bet_item[rule_id: #{rule_id}, rule_name: #{rule_name}, rule_eval: #{rule_eval}]")
        bet_item = new_bet_item(ball_id, bet_credit, today_stat, "third", rule_id, rule_name, rule_eval)
        bet_rule = @lottery.bet_rule(rule_id)
        bet_rule.bet_count = bet_rule.bet_count + 1
        bet_rule.total_income = bet_rule.total_income.to_f + bet_credit
        bet_rule.total_outcome = bet_rule.total_outcome.to_f + bet_item.possible_win_credit
        #bet_item.save!
        bet_items << bet_item
      end
    end

    bet_items.each {|item| item.save!}

    total_bet_credit = bet_items.inject(0) { |sum, item| sum + item.credit }
    #@current_user.available_credit = @current_user.available_credit - total_bet_credit
    @current_user.available_credit = (@current_user.available_credit - total_bet_credit).round(4)
    @current_user.save!

    current_lottery.total_income = (current_lottery.total_income + total_bet_credit).round(4)
    current_lottery.save!

  end

  def handle_sum_bet(ball_id, bet_params)
    today_stat = UserDailyStat.get_current_stat(@current_user, @lottery.lottery_date)
    bet_items = []

    sum_params = bet_params[:sum]

    HALF_BET_ITEMS.each do |item, item_name|
      bet_credit = sum_params[item].to_i
      if bet_credit > 0
        rule_id = "sum_#{item}"
        rule_name = BALL_NAMES[ball_id] + " 開 總和" + item_name
        rule_eval = "ball_#{ball_id}.#{item}"
        logger.info("new bet_item[rule_id: #{rule_id}, rule_name: #{rule_name}, rule_eval: #{rule_eval}]")
        bet_item = new_bet_item(ball_id, bet_credit, today_stat, "half", rule_id, rule_name, rule_eval)
        bet_rule = @lottery.bet_rule(rule_id)
        bet_rule.bet_count = bet_rule.bet_count + 1
        bet_rule.total_income = bet_rule.total_income.to_f + bet_credit
        bet_rule.total_outcome = bet_rule.total_outcome.to_f + bet_item.possible_win_credit
        #bet_item.save!
        bet_items << bet_item
      end
    end

    (1..8).each do |ball_index|
      ball_params = bet_params["ball_#{ball_index}"]
      next if ball_params.nil?

      HALF_BET_ITEMS.each do |item, item_name|
        bet_credit = ball_params[item].to_i
        if bet_credit > 0
          rule_id = "ball_#{ball_index}_#{item}"
          rule_name = BALL_NAMES[ball_index] + " 開 " + item_name
          rule_eval = "ball_#{ball_index}.#{item}"
          logger.info("new bet_item[rule_id: #{rule_id}, rule_name: #{rule_name}, rule_eval: #{rule_eval}]")
          bet_item = new_bet_item(ball_index, bet_credit, today_stat, "half", rule_id, rule_name, rule_eval)
          bet_rule = @lottery.bet_rule(rule_id)
          bet_rule.bet_count = bet_rule.bet_count + 1
          bet_rule.total_income = bet_rule.total_income.to_f + bet_credit
          bet_rule.total_outcome = bet_rule.total_outcome.to_f + bet_item.possible_win_credit
          #bet_item.save!
          bet_items << bet_item
        end
      end
    end

    bet_items.each {|item| item.save!}

    total_bet_credit = bet_items.inject(0) { |sum, item| sum + item.credit }
    @current_user.available_credit = (@current_user.available_credit - total_bet_credit).round(4)
    @current_user.save!

    current_lottery.total_income = (current_lottery.total_income + total_bet_credit).round(4)
    current_lottery.save!
  end

  def handle_cp_bet(ball_id, bet_params)
    today_stat = UserDailyStat.get_current_stat(@current_user, @lottery.lottery_date)
    bet_items = []

    c_type = bet_params[:c_type]
    bet_type = c_type[0]
    bet_gnum = c_type[1].to_i
    bet_credit = bet_params[:credit].to_d
    bet_nos = bet_params[:c_type_no].collect{|no| no.to_i }
    bet_groups = bet_nos.combination(bet_gnum)

    method_name = case bet_type
                    when "c"
                      "is_c?"
                    when "s"
                      "is_s?"
                    when "x"
                      "is_ps?"
                  end

    bet_groups.each do |group|
      eval_expr = "#{method_name}(#{group})"
      rule_id = "#{c_type}_#{group}"
      rule_name = COMB_NAMES[c_type.to_sym] + " 開 " + group.to_s
      rule_eval = "#{method_name}(#{group})"
      logger.info("new bet_item[rule_id: #{rule_id}, rule_name: #{rule_name}, rule_eval: #{rule_eval}]")
      bet_item = new_bet_item(ball_id, bet_credit, today_stat, c_type, rule_id, rule_name, rule_eval)
      bet_rule = @lottery.bet_rule(rule_id)
      bet_rule.bet_count = bet_rule.bet_count + 1
      bet_rule.total_income = bet_rule.total_income.to_f + bet_credit
      bet_rule.total_outcome = bet_rule.total_outcome.to_f + bet_item.possible_win_credit
      #bet_item.save!
      bet_items << bet_item
    end


    bet_items.each {|item| item.save!}

    total_bet_credit = bet_items.inject(0) { |sum, item| sum + item.credit }
    #@current_user.available_credit = @current_user.available_credit - total_bet_credit
    @current_user.available_credit = (@current_user.available_credit - total_bet_credit).round(4)
    @current_user.save!

    current_lottery.total_income = (current_lottery.total_income + total_bet_credit).round(4)
    current_lottery.save!


  end


  def new_bet_item(ball_id, bet_credit, today_stat, odds_rule, rule_id, rule_name, rule_eval)
    bet_item = BetItem.new
    bet_item.ball_no = ball_id
    bet_item.user = @current_user
    bet_item.agent = @current_user.agent
    bet_item.top_user = @current_user.top_user
    bet_item.user_daily_stat = today_stat
    bet_item.lottery_inst = current_lottery
    bet_item.bet_time = Time.now
    bet_item.lottery_full_id = bet_item.lottery_inst.lottery_full_id
    bet_item.bet_rule_type = rule_id
    bet_item.bet_rule_name = rule_name
    bet_item.bet_rule_eval = rule_eval
    bet_item.credit = bet_credit
    # 如果用户的退水多于盘面退水，则用盘面退水
    bet_item.user_return_rate = [@current_user.return, @odds_level.return].min
    bet_item.agent_return_rate = @odds_level.return
    bet_item.user_return = (bet_item.credit * bet_item.user_return_rate).round(4)
    bet_item.agent_return = (bet_item.credit * (bet_item.agent_return_rate - bet_item.user_return_rate)).round(4)
    bet_item.total_return = (bet_item.credit * bet_item.agent_return_rate).round(4)
    bet_item.odds = @odds_level.rule_by_name(odds_rule).odds
    bet_item.possible_win_credit = (bet_item.credit * bet_item.odds).round(4)
    bet_item
  end



  def init
    gon.total_credit = current_user.total_credit
    gon.available_credit = current_user.available_credit
    @lottery = current_lottery
    @previous_lottery = previous_lottery
    @current_daily_stat = UserDailyStat.get_current_stat(current_user, @lottery.lottery_date)

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

    @sum_analyst = LotteryAnalyst.by_sum(10)

  end


end
