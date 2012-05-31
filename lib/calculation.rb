class Calculation
  def self.compute(lottery_inst, lottery_pred)
    outcome = lottery_inst.bet_items.inject(0) do |total, item|
      Rails.logger.debug("checking item[bet_rule_type: #{item.bet_rule_type}, bet_rule_eval: #{item.bet_rule_eval}, bet_rule_name: #{item.bet_rule_name}")
      if lottery_pred.send(:eval, item.bet_rule_eval)
        Rails.logger.info("win -> #{item.possible_win_credit.to_f}")
        total = total + item.possible_win_credit
      end
      total
    end

    outcome
  end

  def self.balance_lottery(lottery_inst)
    total = 0.0
    total_agent_return = 0.0
    lottery_inst.bet_items.each do |item|
      Rails.logger.debug("checking item[bet_rule_type: #{item.bet_rule_type}, bet_rule_eval: #{item.bet_rule_eval}, bet_rule_name: #{item.bet_rule_name}")
      if lottery_inst.send(:eval, item.bet_rule_eval)
        user = item.user
        item.is_win = true
        item.result = item.possible_win_credit + item.user_return
        Rails.logger.info("user[username: #{user.username}] win -> #{item.possible_win_credit.to_f}")
        total = total + item.possible_win_credit
      else
        user = item.user
        item.is_win = false
        item.result = - (item.credit - item.user_return)
        Rails.logger.info("user[username: #{user.username}] lose -> #{item.credit.to_f}")
      end
      item.result = item.result.round(2)
      total_agent_return = (total_agent_return + item.agent_return).round(2)
    end

    lottery_inst.total_outcome = (total - total_agent_return).round(2)
    lottery_inst.profit = (lottery_inst.total_income - lottery_inst.total_outcome - total_agent_return).round(2)

    lottery_inst.save!

  end

  def self.balance_user(lottery_inst, want_save = true)
    user_data = {}
    lottery_inst.bet_items.each do |item|
      total = user_data[item.user] || 0.0
      Rails.logger.debug("user_dta[#{item.user.id}] => #{total.to_f}")
      if item.is_win
        # 加上总赢数
        total = total + item.result
        Rails.logger.debug("item.result => #{item.result.to_f}, user_dta[#{item.user.id}] => #{total.to_f}")
      else
        # 没中的，加上退水
        total = total + item.user_return
        Rails.logger.debug("item.user_return => #{item.user_return.to_f}, user_dta[#{item.user.id}] => #{total.to_f}")
      end
      user_data[item.user] = total
    end

    user_data.each do |user, total|
      user.available_credit = (user.available_credit + total.round(2))
      user.save! if want_save
    end
  end

  def self.rollback_balance_user(lottery_inst, want_save = true)
    user_data = {}
    lottery_inst.bet_items.each do |item|
      total = user_data[item.user] || 0.0
      if item.is_win
        total = total + item.result
      else
        total = total + item.user_return
      end
      user_data[item.user] = total
    end

    user_data.each do |user, total|
      user.available_credit = (user.available_credit - total.round(2))
      user.save! if want_save
    end
  end


  def self.update_daily_stat(lottery_inst)
    user_daily_stats = lottery_inst.bet_items.collect{ |item| item.user_daily_stat }.uniq
    user_daily_stats.each do |uds|
      total_win = 0.0
      total_return = 0.0
      uds.bet_items.each do |item|
        total_win = total_win + item.result
        total_return = total_return + item.user_return
      end
      uds.total_win = total_win.round(2)
      uds.total_return = total_return.round(2)
      uds.save!
    end
  end

end