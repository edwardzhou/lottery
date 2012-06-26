#encoding: utf-8
require "calculation"

class LotteryConfig
  include Mongoid::Document

  field :lottery_date, type: Date
  field :next_seq_no, type: Integer, default: 1
  field :next_start_time, type: Time
  field :day_start_hour, type: Integer, default: 8
  field :day_start_minute, type: Integer, default: 0
  field :day_end_hour, type: Integer, default: 22
  field :day_end_minute, type: Integer, default: 0
  field :active, type: Boolean, default: false
  belongs_to :lottery_def
  belongs_to :lottery_inst
  belongs_to :previous_lottery, :class_name => "LotteryInst"

  def move_to_next
    self.next_seq_no = self.next_seq_no.next
    self.next_start_time = self.next_start_time + self.lottery_def.period.minutes
    save!
  end

  def reset_seq_no(the_date)
    self.lottery_date = the_date.to_date
    self.next_seq_no = 1
    start_time = lottery_def.start_time.strftime("%H:%M:%S +0800")
    self.next_start_time = Time.parse(the_date.strftime("%Y%m%d " + start_time))
    save!

    LotteryAnalyst.reset_all

    self
  end

  def start_new_lottery
    unless self.lottery_inst.closed
      Rails.logger.debug("lottery_inst is not closed, start to close it")
      Calculation.close_lottery(self.lottery_inst)
    end

    #unless self.lottery_inst.balanced
    #  Rails.logger.debug("lottery_inst is not, start to balance all")
    #  Calculation.balance_all(self.lottery_inst)
    #end

    #if self.lottery_date.to_time < Time.now.beginning_of_day
    #  reset_seq_no(Time.now.beginning_of_day)
    #end

    if self.next_seq_no > 108
      #reset_seq_no(self.next_start_time.to_date.next.to_time)
      reset_seq_no(self.lottery_date.to_date.next.to_time)
    end

    LotteryAnalyst.update_analyst(self.lottery_inst)

    lottery = LotteryInst.new
    lottery.lottery_name = self.lottery_def.lottery_name
    lottery.lottery_date = self.lottery_date
    lottery.lottery_seq_no = self.next_seq_no
    lottery.period = self.lottery_def.period
    lottery.lottery_full_id = lottery.lottery_date.strftime("%Y%m%d") + format("%03d", lottery.lottery_seq_no)
    lottery.start_time = self.next_start_time
    lottery.end_time = lottery.start_time + lottery_def.period.minutes
    lottery.close_at = lottery.end_time - 3.minutes
    lottery.active = true
    lottery.return_rate = self.lottery_def.return_rate
    lottery.total_income = 0
    lottery.total_outcome = 0
    lottery.profit = 0
    lottery.is_first = self.next_seq_no == 1
    lottery.is_first_started = false
    lottery.is_last = self.next_seq_no == 108
    lottery.accept_betting = !lottery.is_first
    lottery.balance_at = lottery.end_time + (30 + rand(90)).seconds


    # 复制各盘赔率
    self.lottery_def.odds_levels.each do |ol|
      level = ol.dup
      level.lottery_def = nil
      lottery.odds_levels << level
    end

    # 复制球
    self.lottery_def.balls.each do |ball|
      new_ball = ball.dup
      lottery.balls << new_ball
    end

    # 复制投注项规则
    self.lottery_def.bet_rules.each do |rule|
      new_rule = rule.dup
      lottery.bet_rules << rule
    end

    lottery.save!

    self.previous_lottery = self.lottery_inst
    self.lottery_inst = lottery
    self.move_to_next
    self.save!

    lottery
  end

end