#encoding: utf-8

class HomeController < ApplicationController

  include ApplicationHelper

  def index

  end


  def user
  end

  def rule_info

  end

  def bet_list
    @bet_items = BetItem.bet_items_by_user(current_user, current_lottery)
    @total_rows = @bet_items.count
    rows_per_page = params[:rows] || 20
    @page = params[:page].to_i
    @pages = (@total_rows / rows_per_page.to_f).ceil

    @page = @pages if @page > @pages

    if request.xhr?
      @bet_items = @bet_items.order_by(params[:sidx].to_sym => params[:sord]).paginate(:page => params[:page], :per_page => rows_per_page)
    end
    @user_data = {bet_rule_name: "合計", credit: 0.0, possible_win_credit: 0.0, total_return: 0.0 }
    @bet_items.each do |item|
      @user_data[:credit] = @user_data[:credit] + item.credit
      @user_data[:possible_win_credit] = @user_data[:possible_win_credit] + item.possible_win_credit
      @user_data[:total_return] = @user_data[:total_return] + item.total_return
    end

  end

end
