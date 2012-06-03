require "lottery_task"
class Admin::TasksController < ApplicationController
  skip_before_filter :login_required

  def index
    Thread.new {
      LotteryTask.new.lottery_process
    }
  end

end
