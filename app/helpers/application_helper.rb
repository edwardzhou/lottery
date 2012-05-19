module ApplicationHelper
  def current_user
    return nil if session[:user_id].nil?

    @current_user ||= User.find(session[:user_id])

    @current_user
  end

  def current_lottery
    return nil if session[:user_id].nil?

    @current_lottery ||= LotteryConfig.first.lottery_inst
  end
end
