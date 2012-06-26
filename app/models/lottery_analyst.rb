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
  field :appr_data, type: Array, default: Array.new
  include Mongoid::Timestamps

  scope :by_sum, lambda {|count| where(:analyst_group => "sum", :appr_count.gt => 2).order_by(:appr_count => :desc).limit(count) }
  scope :by_group, lambda {|group_name| where(:analyst_group => group_name).order_by(:analyst_id => :asc) }

  def self.reset_all
    update_all(:appr_count => 0, :no_appr_count => 0, :appr_data => [])
  end

  def self.reset_count(before_time)
    where(:analyst_group => "no_no_appr", :updated_at.lt => before_time).to_a.each do |la|
      la.no_appr_count = la.no_appr_count + 1
      la.save!
    end
    where(:updated_at.lt => before_time).and(:analyst_group.not => /ball_\d\d?_appr/).update(:appr_count => 0)
  end

  def self.get_by_id(id, create_on_not_found = true)
    if create_on_not_found
      LotteryAnalyst.find_or_create_by(:analyst_id => id)
    else
      LotteryAnalyst.where(:analyst_id => id).first
    end
  end

  def self.update_analyst(lottery)
    current_time = Time.now

    self.update_balls_analyst(lottery)
    self.update_sum_analyst(lottery)

    self.reset_count(current_time)

  end

  private
  def self.update_balls_analyst(lottery)
    (1..8).each do |ball_id|
      ball = lottery.send(:eval, "ball_#{ball_id}")

      (1..20).each do |index|
        a_id = "ball_#{ball_id}_#{format('%02d', index)}"
        la = self.get_by_id(a_id)
        la.analyst_name ||= "#{BALL_NAMES[ball_id]} - #{format('%02d', index)}"
        la.analyst_group ||= "ball_#{ball_id}_appr"
        if ball.ball_value == index
          la.appr_count = la.appr_count + 1
        else
          #la.no_appr_count = la.no_appr_count + 1
          #la.appr_count = 0
        end
        la.save!

        no_appr_la = self.get_by_id("no_#{format("%02d", index)}_no_appr")
        no_appr_la.analyst_name ||= "#{format("%02d", index)} - 無出期數"
        no_appr_la.analyst_group ||= "no_no_appr"
        no_appr_la.save!
      end

      # 复位无出期数
      no_appr_a_id = "no_#{format("%02d", ball.ball_value)}_no_appr"
      no_appr_la = self.get_by_id(no_appr_a_id)
      no_appr_la.analyst_name ||= "#{format("%2d", ball.ball_value)} 無出期數"
      no_appr_la.analyst_group ||= "no_no_appr"
      no_appr_la.no_appr_count = 0
      no_appr_la.save!


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

=begin
      # 大小
      a_id = "ball_#{ball_id}_big_small_seq"
      la = self.get_by_id(a_id)
      la.analyst_name ||= "#{BALL_NAMES[ball_id]} - 大小"
      la.analyst_group ||= "ball_#{ball_id}_big_small_sum"
      item_name = ball.big ? "大" : "小"
      if la.appr_data.size == 0
        la.appr_data.push([ item_name , 1])
      else
        last_item = la.appr_data.last
        if last_item[0] == item_name
          last_item[1] = last_item[1] + 1
        else
          la.appr_data.push( [item_name, 1] )
        end
      end
      la.appr_data.shift if la.appr_data.size > 25
=end

      self.update_ball_sum_analyst(ball, ball_id, "big_small", "big", "大小", ["大", "小"])
      self.update_ball_sum_analyst(ball, ball_id, "odd_even", "odd", "單雙", ["單", "雙"])
      self.update_ball_sum_analyst(ball, ball_id, "trail_big_small", "trail_big", "尾數大小", ["大", "小"])
      self.update_ball_sum_analyst(ball, ball_id, "add_odd_even", "add_odd", "合數單雙", ["單", "雙"])
      self.update_ball_dir_analyst(ball, ball_id)
      self.update_ball_zfb_analyst(ball, ball_id)
      self.update_ball_appr_seq_analyst(ball, ball_id)

    end

  end

  def self.update_ball_sum_analyst(ball, ball_id, sum_id, sum_eval, sum_name, sum_values )
    # 大小
    a_id = "ball_#{ball_id}_#{sum_id}_seq"
    la = self.get_by_id(a_id)
    la.analyst_name ||= "#{BALL_NAMES[ball_id]} - #{sum_name}"
    la.analyst_group ||= "ball_#{ball_id}_#{sum_id}"
    item_name = ball.send(:eval, sum_eval) ? sum_values[0] : sum_values[1]
    if la.appr_data.size == 0
      la.appr_data.push([ item_name , 1])
    else
      last_item = la.appr_data.last
      if last_item[0] == item_name
        last_item[1] = last_item[1] + 1
      else
        la.appr_data.push( [item_name, 1] )
      end
    end
    la.appr_data.shift if la.appr_data.size > 25

    la.save!
  end

  def self.update_ball_dir_analyst(ball, ball_id)
    # 大小
    a_id = "ball_#{ball_id}_dir_seq"
    la = self.get_by_id(a_id)
    la.analyst_name ||= "#{BALL_NAMES[ball_id]} - 方位"
    la.analyst_group ||= "ball_#{ball_id}_dir"
    item_name = case
                  when ball.east
                    "東"
                  when ball.south
                    "南"
                  when ball.west
                    "西"
                  else
                    "北"
                end

    if la.appr_data.size == 0
      la.appr_data.push([ item_name , 1])
    else
      last_item = la.appr_data.last
      if last_item[0] == item_name
        last_item[1] = last_item[1] + 1
      else
        la.appr_data.push( [item_name, 1] )
      end
    end
    la.appr_data.shift if la.appr_data.size > 25

    la.save!
  end

  def self.update_ball_zfb_analyst(ball, ball_id)
    # 大小
    a_id = "ball_#{ball_id}_zfb_seq"
    la = self.get_by_id(a_id)
    la.analyst_name ||= "#{BALL_NAMES[ball_id]} - 中發白"
    la.analyst_group ||= "ball_#{ball_id}_dir"
    item_name = case
                  when ball.middle
                    "中"
                  when ball.fa
                    "發"
                  else
                    "白"
                end

    if la.appr_data.size == 0
      la.appr_data.push([ item_name , 1])
    else
      last_item = la.appr_data.last
      if last_item[0] == item_name
        last_item[1] = last_item[1] + 1
      else
        la.appr_data.push( [item_name, 1] )
      end
    end
    la.appr_data.shift if la.appr_data.size > 25

    la.save!
  end

  def self.update_ball_appr_seq_analyst(ball, ball_id)
    # 大小
    a_id = "ball_#{ball_id}_appr_seq"
    la = self.get_by_id(a_id)
    la.analyst_name ||= "#{BALL_NAMES[ball_id]} - 出球"
    la.analyst_group ||= "ball_#{ball_id}_appr_seq"
    item_name = format("%02d", ball.ball_value)

    if la.appr_data.size == 0
      la.appr_data.push([ item_name , 1])
    else
      last_item = la.appr_data.last
      if last_item[0] == item_name
        last_item[1] = last_item[1] + 1
      else
        la.appr_data.push( [item_name, 1] )
      end
    end
    la.appr_data.shift if la.appr_data.size > 25

    la.save!
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

    self.update_ball_sum_analyst(ball, 9, "big_small", "big", "大小", ["大", "小"])
    self.update_ball_sum_analyst(ball, 9, "odd_even", "odd", "單雙", ["單", "雙"])
    self.update_ball_sum_analyst(ball, 9, "trail_big_small", "trail_big", "尾大小", ["大", "小"])
    self.update_ball_sum_analyst(ball, 9, "add_odd_even", "add_odd", "合數單雙", ["單", "雙"])
    self.update_ball_sum_analyst(ball, 9, "dragon_tiger", "dragon", "龍虎", ["龍", "虎"])

  end



end