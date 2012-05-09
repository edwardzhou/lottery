class Admin::LotteryDefsController < ApplicationController

  def index
    @lottery_defs = LotteryDef.all
  end

  def show
    @lottery_def = LotteryDef.find(params[:id])

  end

end
