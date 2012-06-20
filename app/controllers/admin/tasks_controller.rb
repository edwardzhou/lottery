require "lottery_task"
class Admin::TasksController < ApplicationController
  skip_before_filter :login_required
  before_filter :check_local_ip

  def reset_av_credit
    LotteryTask.reset_available_credits
    render :text => "reset ok. #{Time.now}"
  end

  private
  def check_local_ip
    if request.remote_ip != "127.0.0.1"
      logger.warn("wrong task invoke from #{request.remote_ip}. redirect to home page")
      redirect_to root_path
    end
  end

end
