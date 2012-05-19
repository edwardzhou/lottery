class LotteryConfig
  include Mongoid::Document

  field :lottery_date, type: Date
  field :next_seq_no, type: Integer, default: 1
  field :next_start_time, type: Time
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
    start_time = lottery_def.strftime("%H:%M:%S +0800")
    self.next_start_time = Time.parse(the_date.strftime("%Y%m%d " + start_time))
    save!
    self
  end

  def start_new_lottery
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

    self.lottery_def.odds_levels.each do |ol|
      level = ol.dup
      level.lottery_def = nil
      lottery.odds_levels << level
    end

    self.lottery_def.balls.each do |ball|
      new_ball = ball.dup
      lottery.balls << new_ball
    end

    lottery.save!

    self.previous_lottery = self.lottery_inst
    self.lottery_inst = lottery
    self.move_to_next
    self.save!

    lottery
  end

end