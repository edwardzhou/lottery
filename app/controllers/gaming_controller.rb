#encoding: utf-8

class GamingController < ApplicationController

  def index
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
  end

end
