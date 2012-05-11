class LotteriesController < ApplicationController

  before_filter :load_lottery

  def show
    @ball_id = params[:id]

  end


  private
  def load_lottery
    @lottery = Lottery.where({active: true}).first
  end


end
