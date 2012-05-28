class LotteryInst

  include Mongoid::Document

  field :lottery_name, type: String
  field :lottery_full_id, type: String
  field :lottery_date, type: Date
  field :lottery_seq_no, type: Integer
  field :description, type: String
  field :start_time, type: Time
  field :end_time, type: Time
  field :close_at, type: Time
  field :period, type: Integer
  field :active, type: Boolean
  field :return_rate, type: Integer
  field :total_income, type: BigDecimal
  field :total_outcome, type: BigDecimal
  field :profit, type: BigDecimal

=begin
  field :ball_1, type: Integer
  field :ball_1_trail, type: Integer #1号球尾数
  field :ball_1_add, type: Integer #1号球合数
  field :ball_2, type: Integer
  field :ball_2_trail, type: Integer #2号球尾数
  field :ball_2_add, type: Integer #2号球合数
  field :ball_3, type: Integer
  field :ball_3_trail, type: Integer #3号球尾数
  field :ball_3_add, type: Integer #3号球合数
  field :ball_4, type: Integer
  field :ball_4_trail, type: Integer #4号球尾数
  field :ball_4_add, type: Integer #4号球合数
  field :ball_5, type: Integer
  field :ball_5_trail, type: Integer #5号球尾数
  field :ball_5_add, type: Integer #5号球合数
  field :ball_6, type: Integer
  field :ball_6_trail, type: Integer #6号球尾数
  field :ball_6_add, type: Integer #6号球合数
  field :ball_7, type: Integer
  field :ball_7_trail, type: Integer #7号球尾数
  field :ball_7_add, type: Integer #7号球合数
  field :ball_8, type: Integer
  field :ball_8_trail, type: Integer #8号球尾数
  field :ball_8_add, type: Integer #8号球合数
  field :ball_9, type: Integer #总和
  field :ball_9_trail, type: Integer #总和尾数
  field :ball_9_add, type: Integer #总和合数
  field :ball_10, type: Integer #龙虎 (1 龙， 2 虎)
=end

  embeds_one :ball_1, :class_name => "Ball"
  embeds_one :ball_2, :class_name => "Ball"
  embeds_one :ball_3, :class_name => "Ball"
  embeds_one :ball_4, :class_name => "Ball"
  embeds_one :ball_5, :class_name => "Ball"
  embeds_one :ball_6, :class_name => "Ball"
  embeds_one :ball_7, :class_name => "Ball"
  embeds_one :ball_8, :class_name => "Ball"
  embeds_one :ball_9, :class_name => "Ball"
  embeds_one :ball_10, :class_name => "Ball"

  embeds_many :bet_rules
  embeds_many :balls

  embeds_many :odds_levels
  embeds_many :prize_balls, :class_name => "Ball"

  include Mongoid::Timestamps

  def get_odds_level(level_id)
    if @odds_level_map.nil?
      @odds_level_map = {}
      odds_levels.each {|l| @odds_level_map[l.level_id] = l}
    end

    @odds_level_map[level_id]
  end

  def bet_rule(rule_id)
    rule_id = rule_id.to_sym unless rule_id.kind_of?(Symbol)
    self.bet_rules.where(rule_id: rule_id).first
  end

  def set_ball_values(balls_values)
    if self.ball_1.nil?
      self.ball_1 = Ball.new
    end
    if self.ball_2.nil?
      self.ball_2 = Ball.new
    end
    if self.ball_3.nil?
      self.ball_3 = Ball.new
    end
    if self.ball_4.nil?
      self.ball_4 = Ball.new
    end
    if self.ball_5.nil?
      self.ball_5 = Ball.new
    end
    if self.ball_6.nil?
      self.ball_6 = Ball.new
    end
    if self.ball_7.nil?
      self.ball_7 = Ball.new
    end
    if self.ball_8.nil?
      self.ball_8 = Ball.new
    end

    self.ball_1.set_value(balls_values[:ball_1])
    self.ball_2.set_value(balls_values[:ball_2])
    self.ball_3.set_value(balls_values[:ball_3])
    self.ball_4.set_value(balls_values[:ball_4])
    self.ball_5.set_value(balls_values[:ball_5])
    self.ball_6.set_value(balls_values[:ball_6])
    self.ball_7.set_value(balls_values[:ball_7])
    self.ball_8.set_value(balls_values[:ball_8])

  end


end