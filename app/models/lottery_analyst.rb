#encoding: utf-8

require "lottery_rule_names"

class LotteryAnalyst

  include LotteryRuleNames

  include Mongoid::Document
  field :analyst_id, type: String
  field :analyst_name, type: String
  field :analyst_group, type: String
  field :appr_count, type: Integer, default: 0
  field :no_appr_count, type: Integer, default: 0
  include Mongoid::Timestamps

  scope :by_sum, lambda {|count| where(:analyst_group => "sum", :appr_count.gt => 2).order_by(:appr_count => :desc).limit(count) }

  def self.reset_count(before_time)
    where(:updated_at.lt => before_time).update(:appr_count => 0)
  end

  def self.get_by_id(id)
    LotteryAnalyst.find_or_create_by(:analyst_id => id)
  end

  def self.update_analyst(lottery)
    self.update_balls_analyst(lottery)
    self.update_sum_analyst(lottery)
  end

  private
  def self.update_balls_analyst(lottery)
    (1..8).each do |ball_id|
      ball = lottery.send(:eval, "ball_#{ball_id}")
      (1..20).each do |index|
        a_id = "ball_#{ball_id}_#{index}"
        la = self.get_by_id(a_id)
        la.analyst_name ||= "#{BALL_NAMES[ball_id]} - #{format('%02d', index)}"
        la.analyst_group ||= "ball"
        if ball.ball_value == index
          la.appr_count = la.appr_count + 1
          la.no_appr_count = 0
        else
          la.no_appr_count = la.no_appr_count + 1
          la.appr_count = 0
        end
        la.save!
      end

      HALF_BET_ITEMS.each do |key, name|
        a_id = "ball_#{ball_id}_#{key}"
        la = self.get_by_id(a_id)
        la.analyst_name ||= "#{BALL_NAMES[ball_id]} - #{name}"
        la.analyst_group ||= "sum"
        if ball.send(:eval, "#{key}")
          la.appr_count = la.appr_count + 1
        else
          la.appr_count = 0
        end
        la.save!
      end

      QUARTER_BET_ITEMS.each do |key, name|

      end

      THIRD_BET_ITEMS.each do |key, name|

      end

    end

  end

  def self.update_sum_analyst(lottery)
    ball = lottery.ball_9
    HALF_BET_ITEMS.each do |key, name|
      a_id = "ball_9_#{key}"
      la = self.get_by_id(a_id)
      la.analyst_name ||= "總和#{name}"
      la.analyst_group ||= "sum"
      if ball.send(:eval, "#{key}")
        la.appr_count = la.appr_count + 1
      else
        la.appr_count = 0
      end
      la.save!
    end
  end

end