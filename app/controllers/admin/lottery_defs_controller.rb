class Admin::LotteryDefsController < ApplicationController

  def index
    @lottery_defs = LotteryDef.all
  end

end
