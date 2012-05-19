#encoding: utf-8

class GamingController < ApplicationController

  include ApplicationHelper

  before_filter :init

  #helper_method

  def index

  end

  def show
    id = params[:id]
    ball_id = 0
    ball_regex = /^ball(\d\d?)$/
    if id =~ ball_regex then
      ball_id = ball_regex.match(id)[1].to_i
    end

    if ball_id == 0
      render :action => "index"
    elsif ball_id
      @ball = current_lottery.balls[ball_id - 1]
    end

    gon.ball_url = gaming_path(id, format: :json)

    if ball_id > 8 and not request.xhr?
      render "ball9"
    end


  end


  private
  def init
    @lottery = LotteryInst.where({:active => true}).first

    @odds_rules = {}
    @odds_rules[:LEVEL_A] = { :exact => 19.6, :half => 1.984, :quarter => 3.92,
                              :third => 2.79, :c2 => 20, :p2 => 20, :c3 => 30,
                              :p3 => 30, :c4 => 60, :p4 => 60, :c5 => 200, :p5 => 200, :return => 0.005}
    @odds_rules[:LEVEL_B] = { :exact => 19.3, :half => 1.93, :quarter => 3.82,
                              :third => 2.59, :c2 => 18, :p2 => 18, :c3 => 28,
                              :p3 => 28, :c4 => 58, :p4 => 58, :c5 => 198, :p5 => 198, :return => 0.008}
    @odds_rules[:LEVEL_C] = { :exact => 19, :half => 1.9, :quarter => 3.72,
                              :third => 2.39, :c2 => 16, :p2 => 16, :c3 => 26,
                              :p3 => 26, :c4 => 56, :p4 => 56, :c5 => 190, :p5 => 190, :return => 0.010}


    @odds_level = current_lottery.get_odds_level(current_user.odds_level.level_id)


    @sum_bet_odd_even_rules = []
    @sum_bet_odd_even_rules << Rule.new({:rule_name => "sum[odd]", :rule_title => "總和單", :odds => "1.984"})
    @sum_bet_odd_even_rules << Rule.new({:rule_name => "sum[even]", :rule_title => "總和雙", :odds => "1.984"})

    @sum_bet_big_small_rules = []
    @sum_bet_big_small_rules << Rule.new({:rule_name => "sum[big]", :rule_title => "總和大", :odds => "1.984"})
    @sum_bet_big_small_rules << Rule.new({:rule_name => "sum[small]", :rule_title => "總和小", :odds => "1.984"})

    @sum_bet_trail_big_small_rules = []
    @sum_bet_trail_big_small_rules << Rule.new({:rule_name => "sum[trail_big]", :rule_title => "總和尾大", :odds => "1.984"})
    @sum_bet_trail_big_small_rules << Rule.new({:rule_name => "sum[trail_small]", :rule_title => "總和尾小", :odds => "1.984"})

    @sum_bet_dt_rules = []
    @sum_bet_dt_rules << Rule.new({:rule_name => "sum[dragon]", :rule_title => "龍", :odds => "1.984"})
    @sum_bet_dt_rules << Rule.new({:rule_name => "sum[tiger]", :rule_title => "虎", :odds => "1.984"})

    @sum_ball_rules = []
    @sum_ball_rules << Rule.new({:rule_name => "big", :rule_title => "大", :odds => "1.984"})
    @sum_ball_rules << Rule.new({:rule_name => "small", :rule_title => "小", :odds => "1.984"})
    @sum_ball_rules << Rule.new({:rule_name => "odd", :rule_title => "單", :odds => "1.984"})
    @sum_ball_rules << Rule.new({:rule_name => "even", :rule_title => "雙", :odds => "1.984"})
    @sum_ball_rules << Rule.new({:rule_name => "trail_big", :rule_title => "尾大", :odds => "1.984"})
    @sum_ball_rules << Rule.new({:rule_name => "trail_small", :rule_title => "尾小", :odds => "1.984"})
    @sum_ball_rules << Rule.new({:rule_name => "add_odd", :rule_title => "合數單", :odds => "1.984"})
    @sum_ball_rules << Rule.new({:rule_name => "add_even", :rule_title => "合數雙", :odds => "1.984"})

    @sum_balls_1 = []
    ball_index = 1
    %w(第一球 第二球 第三球 第四球).each do |ball_name|
      @sum_balls_1 << {:ball_name => ball_name, :ball_no => ball_index, :ball_rules => @sum_ball_rules}
      ball_index = ball_index.next
    end

    @sum_balls_2 = []
    %w(第五球 第六球 第七球 第八球).each do |ball_name|
      @sum_balls_2 << {:ball_name => ball_name, :ball_no => ball_index, :ball_rules => @sum_ball_rules}
      ball_index = ball_index.next
    end

    @ball_rules = []
    @ball_rules << Rule.new({:rule_name => "ball_big", :rule_title => "大", :odds => "1.984"})
    @ball_rules << Rule.new({:rule_name => "ball_small", :rule_title => "小", :odds => "1.984"})
    @ball_rules << Rule.new({:rule_name => "ball_odd", :rule_title => "單", :odds => "1.984"})
    @ball_rules << Rule.new({:rule_name => "ball_even", :rule_title => "雙", :odds => "1.984"})
    @ball_rules << Rule.new({:rule_name => "ball_trail_big", :rule_title => "尾大", :odds => "1.984"})
    @ball_rules << Rule.new({:rule_name => "ball_trail_small", :rule_title => "尾小", :odds => "1.984"})
    @ball_rules << Rule.new({:rule_name => "ball_add_odd", :rule_title => "合數單", :odds => "1.984"})
    @ball_rules << Rule.new({:rule_name => "ball_add_even", :rule_title => "合數雙", :odds => "1.984"})
    @single_ball_rule = Rule.new({:rule_name => "bet", :rule_title => "", :odds => "1.96"})

    @game = Game.new(:game_name => "十分精彩", :game_no => "20120426012", :active => true)
    @game.balls.build({:ball_name => "第一球", :ball_no => 1, :odds => 19.4, :rules => @ball_rules})
    @game.balls.build({:ball_name => "第二球", :ball_no => 2, :odds => 19.4, :rules => @ball_rules})
    @game.balls.build({:ball_name => "第三球", :ball_no => 3, :odds => 19.4, :rules => @ball_rules})
    @game.balls.build({:ball_name => "第四球", :ball_no => 4, :odds => 19.4, :rules => @ball_rules})
    @game.balls.build({:ball_name => "第五球", :ball_no => 5, :odds => 19.4, :rules => @ball_rules})
    @game.balls.build({:ball_name => "第六球", :ball_no => 6, :odds => 19.4, :rules => @ball_rules})
    @game.balls.build({:ball_name => "第七球", :ball_no => 7, :odds => 19.4, :rules => @ball_rules})
    @game.balls.build({:ball_name => "第八球", :ball_no => 8, :odds => 19.4, :rules => @ball_rules})
    #@game.balls.build({:ball_name => "第八球", :ball_no => 8, :odds => 19.4})
    #@game.rules

  end


end
