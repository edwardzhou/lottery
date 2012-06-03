#encoding: utf-8

require "lottery_task"

class HomeController < ApplicationController

  include ApplicationHelper

  def index

  end

  def test
    seconds = params[:s]
    LotteryTask.do_job(seconds.to_i) unless seconds.nil?
  end

  def user
  end

  def rule_info

  end

  def change_password

  end

  def update_password

    @user = current_user
    user_params = params[:user]
    old_pwd, new_pwd, new_pwd_cfm = user_params[:old_pwd], user_params[:new_pwd], user_params[:new_pwd_cfm]
    alert = nil
    if not @user.authenticate(old_pwd)
      alert = "原密碼不匹配,請輸入正確的原密碼！"
    elsif (new_pwd.length < 6)
      alert = "新密码必须长度6位以上!"
    elsif not new_pwd.eql?(new_pwd_cfm)
      alert = "新密码与确认密码不一致!"
    elsif old_pwd.eql?(new_pwd)
      alert = "新密码与原密码不能相同!"
    end

    if not alert.nil?
      redirect_to({:action => :change_password}, :alert => "原密碼不匹配,請輸入正確的原密碼！")
    else
      @user.password = @user.password_confirmation = new_pwd
      @user.save!
      reset_session
      render "update_password", :layout => nil
    end


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
    @user_data = {bet_rule_name: "合計", credit: 0.0, possible_win_credit: 0.0, user_return: 0.0, result: 0.0 }
    @bet_items.each do |item|
      @user_data[:credit] = @user_data[:credit] + item.credit
      @user_data[:possible_win_credit] = @user_data[:possible_win_credit] + item.possible_win_credit
      @user_data[:user_return] = @user_data[:user_return] + item.total_return
      @user_data[:result] = @user_data[:result] + item.result
      @user_data[:result] = @user_data[:result] - item.credit if (item.is_win)
    end

  end

  def bet_stat
    if request.xhr?
      @user_daily_stats = UserDailyStat.recent(current_user)
      @total_rows = @user_daily_stats.count
      @page = 1
      @pages = 1
    end
  end

end
