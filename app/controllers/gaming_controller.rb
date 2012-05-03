#encoding: utf-8

class GamingController < ApplicationController
  before_filter :init

  def index

  end

  def show
    id = params[:id]
    ball_id = 0
    ball_regex = /^ball(\d)$/
    if id =~ ball_regex then
      ball_id = ball_regex.match(id)[1].to_i
    end

    respond_to do |format|
      format.html do
        if ball_id == 0
          render :action => "index"
        elsif ball_id
          @ball = @game.balls[ball_id - 1]
        end
      end

      format.js do
        @odds_level.to_json
      end


    end
  end


  private
  def init
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

    level_a = OddsLevel.new( {:level_name => "A盘", :level_description => "A盘描述", :return => 0.005} )
    level_a.rules << Rule.new({:rule_name => :exact, :rule_title => "单球赔率", :rule_description => "单球赔率",
                               :odds => 19.6, :sort_index => 1})
    level_a.rules << Rule.new({:rule_name => :half, :rule_title => "两面赔率", :rule_description => "单双、大小、龙虎赔率",
                               :odds => 1.984, :sort_index => 20})
    level_a.rules << Rule.new({:rule_name => :third, :rule_title => "三面赔率", :rule_description => "中发白赔率",
                               :odds => 2.79, :sort_index => 30})
    level_a.rules << Rule.new({:rule_name => :quarter, :rule_title => "四面赔率", :rule_description => "东南西北赔率",
                               :odds => 3.92, :sort_index => 40})
    level_a.rules << Rule.new({:rule_name => :c2, :rule_title => "任选二赔率", :rule_description => "任选二赔率",
                               :odds => 20, :sort_index => 50})
    level_a.rules << Rule.new({:rule_name => :p2, :rule_title => "直选二赔率", :rule_description => "直选二赔率",
                               :odds => 20, :sort_index => 60})
    level_a.rules << Rule.new({:rule_name => :c3, :rule_title => "任选三赔率", :rule_description => "任选三赔率",
                               :odds => 30, :sort_index => 70})
    level_a.rules << Rule.new({:rule_name => :p3, :rule_title => "直选三赔率", :rule_description => "直选三赔率",
                               :odds => 30, :sort_index => 80})
    level_a.rules << Rule.new({:rule_name => :c4, :rule_title => "任选四赔率", :rule_description => "任选四赔率",
                               :odds => 60, :sort_index => 90})
    level_a.rules << Rule.new({:rule_name => :p4, :rule_title => "直选四赔率", :rule_description => "直选四赔率",
                               :odds => 600, :sort_index => 100})
    level_a.rules << Rule.new({:rule_name => :c5, :rule_title => "任选五赔率", :rule_description => "任选五赔率",
                               :odds => 200, :sort_index => 110})
    level_a.rules << Rule.new({:rule_name => :p5, :rule_title => "直选五赔率", :rule_description => "直选五赔率",
                               :odds => 200, :sort_index => 120})


    level_b = OddsLevel.new( {:level_name => "B盘", :level_description => "B盘描述", :return => 0.008} )
    level_b.rules << Rule.new({:rule_name => :exact, :rule_title => "单球赔率", :rule_description => "单球赔率",
                               :odds => 19.3, :sort_index => 1})
    level_b.rules << Rule.new({:rule_name => :half, :rule_title => "两面赔率", :rule_description => "单双、大小、龙虎赔率",
                               :odds => 1.93, :sort_index => 20})
    level_b.rules << Rule.new({:rule_name => :third, :rule_title => "三面赔率", :rule_description => "中发白赔率",
                               :odds => 2.59, :sort_index => 30})
    level_b.rules << Rule.new({:rule_name => :quarter, :rule_title => "四面赔率", :rule_description => "东南西北赔率",
                               :odds => 3.82, :sort_index => 40})
    level_b.rules << Rule.new({:rule_name => :c2, :rule_title => "任选二赔率", :rule_description => "任选二赔率",
                               :odds => 18, :sort_index => 50})
    level_b.rules << Rule.new({:rule_name => :p2, :rule_title => "直选二赔率", :rule_description => "直选二赔率",
                               :odds => 18, :sort_index => 60})
    level_b.rules << Rule.new({:rule_name => :c3, :rule_title => "任选三赔率", :rule_description => "任选三赔率",
                               :odds => 28, :sort_index => 70})
    level_b.rules << Rule.new({:rule_name => :p3, :rule_title => "直选三赔率", :rule_description => "直选三赔率",
                               :odds => 28, :sort_index => 80})
    level_b.rules << Rule.new({:rule_name => :c4, :rule_title => "任选四赔率", :rule_description => "任选四赔率",
                               :odds => 58, :sort_index => 90})
    level_b.rules << Rule.new({:rule_name => :p4, :rule_title => "直选四赔率", :rule_description => "直选四赔率",
                               :odds => 58, :sort_index => 100})
    level_b.rules << Rule.new({:rule_name => :c5, :rule_title => "任选五赔率", :rule_description => "任选五赔率",
                               :odds => 198, :sort_index => 110})
    level_b.rules << Rule.new({:rule_name => :p5, :rule_title => "直选五赔率", :rule_description => "直选五赔率",
                               :odds => 198, :sort_index => 120})

    level_c = OddsLevel.new( {:level_name => "C盘", :level_description => "C盘描述", :return => 0.010} )
    level_c.rules << Rule.new({:rule_name => :exact, :rule_title => "单球赔率", :rule_description => "单球赔率",
                               :odds => 19, :sort_index => 1})
    level_c.rules << Rule.new({:rule_name => :half, :rule_title => "两面赔率", :rule_description => "单双、大小、龙虎赔率",
                               :odds => 1.9, :sort_index => 20})
    level_c.rules << Rule.new({:rule_name => :third, :rule_title => "三面赔率", :rule_description => "中发白赔率",
                               :odds => 2.39, :sort_index => 30})
    level_c.rules << Rule.new({:rule_name => :quarter, :rule_title => "四面赔率", :rule_description => "东南西北赔率",
                               :odds => 3.72, :sort_index => 40})
    level_c.rules << Rule.new({:rule_name => :c2, :rule_title => "任选二赔率", :rule_description => "任选二赔率",
                               :odds => 16, :sort_index => 50})
    level_c.rules << Rule.new({:rule_name => :p2, :rule_title => "直选二赔率", :rule_description => "直选二赔率",
                               :odds => 16, :sort_index => 60})
    level_c.rules << Rule.new({:rule_name => :c3, :rule_title => "任选三赔率", :rule_description => "任选三赔率",
                               :odds => 26, :sort_index => 70})
    level_c.rules << Rule.new({:rule_name => :p3, :rule_title => "直选三赔率", :rule_description => "直选三赔率",
                               :odds => 26, :sort_index => 80})
    level_c.rules << Rule.new({:rule_name => :c4, :rule_title => "任选四赔率", :rule_description => "任选四赔率",
                               :odds => 56, :sort_index => 90})
    level_c.rules << Rule.new({:rule_name => :p4, :rule_title => "直选四赔率", :rule_description => "直选四赔率",
                               :odds => 56, :sort_index => 100})
    level_c.rules << Rule.new({:rule_name => :c5, :rule_title => "任选五赔率", :rule_description => "任选五赔率",
                               :odds => 196, :sort_index => 110})
    level_c.rules << Rule.new({:rule_name => :p5, :rule_title => "直选五赔率", :rule_description => "直选五赔率",
                               :odds => 196, :sort_index => 120})



    @odds_levels = {:LEVEL_A => level_a, :LEVEL_B => level_b, :LEVEL_C => level_c}

    if not params[:level].blank?
      @level = params[:level].to_s.upcase.to_sym
    end

    @level ||= :LEVEL_B

    @odds_level = @odds_levels[@level]


    @sum_bet_odd_even_rules = []
    @sum_bet_odd_even_rules << Rule.new({:rule_name => "sum_odd", :rule_title => "總和單", :odds => "1.984"})
    @sum_bet_odd_even_rules << Rule.new({:rule_name => "sum_even", :rule_title => "總和雙", :odds => "1.984"})

    @sum_bet_big_small_rules = []
    @sum_bet_big_small_rules << Rule.new({:rule_name => "sum_big", :rule_title => "總和大", :odds => "1.984"})
    @sum_bet_big_small_rules << Rule.new({:rule_name => "sum_small", :rule_title => "總和小", :odds => "1.984"})

    @sum_bet_trail_big_small_rules = []
    @sum_bet_trail_big_small_rules << Rule.new({:rule_name => "sum_trail_big", :rule_title => "總和尾大", :odds => "1.984"})
    @sum_bet_trail_big_small_rules << Rule.new({:rule_name => "sum_trail_small", :rule_title => "總和尾小", :odds => "1.984"})

    @sum_bet_dt_rules = []
    @sum_bet_dt_rules << Rule.new({:rule_name => "sum_dragon", :rule_title => "龍", :odds => "1.984"})
    @sum_bet_dt_rules << Rule.new({:rule_name => "sum_tiger", :rule_title => "虎", :odds => "1.984"})

    @sum_ball_rules = []
    @sum_ball_rules << Rule.new({:rule_name => "ball_big", :rule_title => "大", :odds => "1.984"})
    @sum_ball_rules << Rule.new({:rule_name => "ball_small", :rule_title => "小", :odds => "1.984"})
    @sum_ball_rules << Rule.new({:rule_name => "ball_odd", :rule_title => "單", :odds => "1.984"})
    @sum_ball_rules << Rule.new({:rule_name => "ball_even", :rule_title => "雙", :odds => "1.984"})
    @sum_ball_rules << Rule.new({:rule_name => "ball_trail_big", :rule_title => "尾大", :odds => "1.984"})
    @sum_ball_rules << Rule.new({:rule_name => "ball_trail_small", :rule_title => "尾小", :odds => "1.984"})
    @sum_ball_rules << Rule.new({:rule_name => "ball_add_odd", :rule_title => "合數單", :odds => "1.984"})
    @sum_ball_rules << Rule.new({:rule_name => "ball_add_even", :rule_title => "合數雙", :odds => "1.984"})

    @sum_balls_1 = []
    ball_index = 1
    %w(第一球 第二球 第三球 第四球).each do |ball_name|
      @sum_balls_1 << {:ball_name => ball_name, :ball_no => ball_index, :ball_rules => @sum_ball_rules}
      ball_index = ball_index.next
    end

    @sum_balls_2 = []
    %w(第五球 第六球 第七球).each do |ball_name|
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
    #@game.balls.build({:ball_name => "第八球", :ball_no => 8, :odds => 19.4})
    #@game.rules

  end


end
