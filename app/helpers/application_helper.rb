#encoding: utf-8

module ApplicationHelper
  def current_user
    return nil if session[:user_id].nil?

    @current_user ||= User.find(session[:user_id])

    @current_user
  end

  def current_lottery
    @current_lottery ||= LotteryConfig.first.lottery_inst
  end

  def previous_lottery
    @previous_lottery ||= LotteryConfig.first.previous_lottery
    if @previous_lottery.nil?
      @previous_lottery = LotteryInst.new({:lottery_name => "无上期记录", :lottery_full_id => lottery_full_id})
    end

    @previous_lottery
  end

end
