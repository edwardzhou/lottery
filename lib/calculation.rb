class Calculation

  @@all_predicts_seed = nil

  def self.load_predict_lottery()
    @@all_predicts_seed = LotteryPredict.all.order_by(:total_income => :asc).to_a if @@all_predicts_seed.nil?
  end

  def self.compute(lottery_inst, lottery_pred)
    outcome = lottery_inst.bet_items.inject(0) do |total, item|
      #Rails.logger.debug("checking item[bet_rule_type: #{item.bet_rule_type}, bet_rule_eval: #{item.bet_rule_eval}, bet_rule_name: #{item.bet_rule_name}")
      if lottery_pred.send(:eval, item.bet_rule_eval)
        #Rails.logger.info("win -> #{item.possible_win_credit.to_f}")
        total = total + item.possible_win_credit
      end
      total
    end
    lottery_pred.total_outcome = outcome
    outcome
  end

  def self.predict_lottery(lottery_inst)

    load_predict_lottery

    max_rand = @@all_predicts_seed.size
    total_start_time = Time.now
    predict_seeds = 500.times.collect do
      lp = @@all_predicts_seed[rand(max_rand)]
      lp.shuffle_balls!
    end

    max_outcome = (lottery_inst.total_income * (lottery_inst.return_rate - 3) / 100.0).round(4)
    max_predicts = {}
    min_predicts = {}


    predict_start_time = Time.now

    if max_outcome <= 0
      Rails.logger.warn("random predict...")
      5.times do
        lp = predict_seeds[rand(predict_seeds.size)]
        max_predicts[lp.balls_to_a] = compute(lottery_inst, lp)
      end
    else
      2.times do |index|
        Rails.logger.info("[#{Time.now}] predict round \##{index} start")
        start_time = Time.now
        ##predicts = predict_seeds.select{|seed| self.compute(lottery_inst, seed) <= max_outcome}
        calc_seeds = predict_seeds.collect do |seed|
          self.compute(lottery_inst, seed)
          seed
        end
        predicts = calc_seeds.select {|seed| seed.total_outcome <= max_outcome}
        #p predicts
        3.times() do
          max_predict = predicts.max{|a,b| a.total_outcome <=> b.total_outcome}
          break if max_predict.nil?
          max_predicts[max_predict.balls_to_a] = max_predict.total_outcome
          predicts.delete(max_predict)
        end
        min_predict = calc_seeds.min { |a, b| a.total_outcome <=> b.total_outcome }
        min_predicts[min_predict.balls_to_a] = min_predict.total_outcome
        end_time = Time.now
        predict_seeds.each(&:shuffle_balls!)
        shuffle_time = Time.now
        Rails.logger.info("[#{Time.now}] predict round \##{index} end. predict[#{end_time-start_time}], shuffle[#{shuffle_time - end_time}]")
      end
    end

    total_end_time = Time.now
    Rails.logger.info("total time: #{total_end_time - total_start_time} , seed prepare time:#{(predict_start_time-total_start_time).seconds} ; total predict time: #{(total_end_time-predict_start_time).seconds}")

    p max_predicts
    if max_predicts.size > 0
      key = max_predicts.keys.shuffle.shuffle.first
      final_result = [key, max_predicts[key]]
      Rails.logger.info("max predicts found, use #{final_result}")
    else
      key = min_predicts.keys.shuffle.shuffle.first
      final_result = [key, min_predicts[key]]
      Rails.logger.info("no max predicts available, use min outcome: #{final_result}")
    end

    final_result
  end

  def self.balance_lottery(lottery_inst)
    total = 0.0
    total_agent_return = 0.0
    lottery_inst.bet_items.each do |item|
      Rails.logger.debug("checking item[bet_rule_type: #{item.bet_rule_type}, bet_rule_eval: #{item.bet_rule_eval}, bet_rule_name: #{item.bet_rule_name}")
      user = item.user
      total_agent_return = total_agent_return + item.agent_return
      if lottery_inst.send(:eval, item.bet_rule_eval)
        item.is_win = true
        item.result = item.possible_win_credit
        item.result_after_return = item.possible_win_credit + item.user_return
        total = total + item.result_after_return + item.agent_return
        Rails.logger.info("user[username: #{user.username}] win -> #{item.possible_win_credit.to_f}")
      else
        item.is_win = false
        item.result = - (item.credit)
        item.result_after_return = - (item.credit - item.user_return)
        total = total + item.total_return
        Rails.logger.info("user[username: #{user.username}] lose -> #{item.credit.to_f}")
      end
      item.result = item.result.round(4)
      total_agent_return = (total_agent_return + item.agent_return).round(4)
    end

    lottery_inst.total_outcome = (total).round(4)
    lottery_inst.profit = (lottery_inst.total_income - lottery_inst.total_outcome).round(4)
    lottery_inst.active = false
    lottery_inst.balanced = true
    lottery_inst.save!

  end



  def self.balance_user(lottery_inst, want_save = true)
    user_data = {}
    lottery_inst.bet_items.each do |item|
      total = user_data[item.user] || 0.0
      Rails.logger.debug("user_dta[#{item.user.id}] => #{total.to_f}")
      if item.is_win
        # 加上总赢数
        total = total + item.result_after_return
        Rails.logger.debug("item.result => #{item.result.to_f}, user_dta[#{item.user.id}] => #{total.to_f}")
      else
        # 没中的，加上退水
        total = total + item.user_return
        Rails.logger.debug("item.user_return => #{item.user_return.to_f}, user_dta[#{item.user.id}] => #{total.to_f}")
      end
      user_data[item.user] = total
    end

    user_data.each do |user, total|
      user.available_credit = (user.available_credit + total.round).round(4)
      user.save! if want_save
    end
  end

  def self.rollback_balance_user(lottery_inst, want_save = true)
    user_data = {}
    lottery_inst.bet_items.each do |item|
      total = user_data[item.user] || 0.0
      if item.is_win
        total = total + item.result_after_return
      else
        total = total + item.user_return
      end
      user_data[item.user] = total
    end

    user_data.each do |user, total|
      user.available_credit = (user.available_credit - total.round(4))
      user.save! if want_save
    end
  end


  def self.update_daily_stat(lottery_inst)
    user_daily_stats = lottery_inst.bet_items.collect{ |item| item.user_daily_stat }.uniq
    user_daily_stats.each do |uds|
      total_win = 0.0
      total_return = 0.0
      total_agent_return = 0.0
      total_bet_credit = 0.0
      total_win_after_return = 0.0
      uds.bet_items.each do |item|
        total_win = total_win + item.result
        total_win = total_win - item.credit if item.is_win
        total_win_after_return = total_win_after_return + item.result_after_return
        total_win_after_return = total_win_after_return - item.credit if item.is_win
        total_return = total_return + item.user_return
        total_agent_return = total_agent_return + item.agent_return
        total_bet_credit = total_bet_credit + item.credit
      end
      uds.total_win = total_win.round(4)
      uds.total_return = total_return.round(4)
      uds.agent = uds.bet_items.first.user.agent if (uds.agent.nil? and not uds.bet_items.first.nil?)
      uds.total_agent_return = total_agent_return.round(4)
      uds.total_bet_credit = total_bet_credit.round(4)
      uds.total_win_after_return = total_win_after_return.round(4)
      uds.save!
    end
  end

  def self.update_agents_daily_stat(lottery_date)
    Rails.logger.debug("update_agent_daily_stat for #{lottery_date}")
    uds = UserDailyStat.by_date(lottery_date)
    agents = uds.collect{|u| u.agent if u.user.user_role == User::USER}.uniq.compact
    agents.each do |agent|
      Rails.logger.debug("agent: #{agent}")
      agent_daily_stat = UserDailyStat.get_current_stat(agent, lottery_date)
      total_bet_credit = 0.0
      total_win = 0.0
      total_win_after_return = 0.0
      total_return = 0.0
      total_agent_return = 0.0

      uds.select{|u| u.agent_id == agent.id}.each do |ds|
        total_bet_credit = total_bet_credit + ds.total_bet_credit
        total_win = total_win + ds.total_win
        total_win_after_return = total_win_after_return + ds.total_win_after_return
        total_return = total_return + ds.total_return
        total_agent_return = total_agent_return + ds.total_agent_return
      end

      agent_daily_stat.agent ||= agent.agent
      agent_daily_stat.top_user ||= agent.agent

      agent_daily_stat.total_bet_credit = total_bet_credit
      agent_daily_stat.total_win = total_win
      agent_daily_stat.total_win_after_return = total_win_after_return
      agent_daily_stat.total_return = total_return
      agent_daily_stat.total_agent_return = total_agent_return

      agent_daily_stat.save!
    end
  end

  def self.update_top_users_daily_stat(lottery_date)
    uds = UserDailyStat.by_date(lottery_date)
    top_users = uds.collect{|u| u.top_user if u.user.user_role == User::USER}.uniq.compact
    top_users.each do |top_user|
      top_user_daily_stat = UserDailyStat.get_current_stat(top_user, lottery_date)
      total_bet_credit = 0.0
      total_win = 0.0
      total_win_after_return = 0.0
      total_return = 0.0
      total_agent_return = 0.0

      uds.select{|u| u.top_user_id == top_user.id}.each do |ds|
        total_bet_credit = total_bet_credit + ds.total_bet_credit
        total_win = total_win + ds.total_win
        total_win_after_return = total_win_after_return + ds.total_win_after_return
        total_return = total_return + ds.total_return
        total_agent_return = total_agent_return + ds.total_agent_return
      end

      top_user_daily_stat.total_bet_credit = total_bet_credit
      top_user_daily_stat.total_win = total_win
      top_user_daily_stat.total_win_after_return = total_win_after_return
      top_user_daily_stat.total_return = total_return
      top_user_daily_stat.total_agent_return = total_agent_return

      top_user_daily_stat.save!
    end
  end


  def self.close_lottery(lottery_inst)
    if lottery_inst.closed
      Rails.logger.debug("lottery_inst.closed => #{lottery_inst.closed}")
      return
    end

    predict_result = nil
    Rails.logger.info("predicting lottery balls.")
    predict_result = predict_lottery(lottery_inst) while predict_result.nil?
    Rails.logger.info("predicted balls #{predict_result[0]}, total_win: #{predict_result[1]}")

    lottery_inst.set_ball_values(predict_result[0])
    lottery_inst.closed = true
    lottery_inst.save!

    LotteryAnalyst.update_analyst(lottery_inst)

    #Rails.logger.info("balance lottery")
    #balance_lottery(lottery_inst)
    #Rails.logger.info("balance users")
    #balance_user(lottery_inst)
    #Rails.logger.info("update daily stat")
    #update_daily_stat(lottery_inst)
    #lottery_inst.balanced = true
    #lottery_inst.save!
    lottery_inst
  end

  def self.balance_all(lottery_inst)
    Rails.logger.info("balance lottery")
    balance_lottery(lottery_inst)
    Rails.logger.info("balance users")
    balance_user(lottery_inst)
    Rails.logger.info("update daily stat")
    update_daily_stat(lottery_inst)
    Rails.logger.info("update agents daily stat")
    update_agents_daily_stat(lottery_inst.lottery_date)
    Rails.logger.info("update top_users daily stat")
    update_top_users_daily_stat(lottery_inst.lottery_date)
    lottery_inst.balanced = true
    lottery_inst.save!
    lottery_inst
  end

end