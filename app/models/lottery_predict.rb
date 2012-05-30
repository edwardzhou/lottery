class LotteryPredict

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


  embeds_one :ball_1, :class_name => "Ball"
  embeds_one :ball_2, :class_name => "Ball"
  embeds_one :ball_3, :class_name => "Ball"
  embeds_one :ball_4, :class_name => "Ball"
  embeds_one :ball_5, :class_name => "Ball"
  embeds_one :ball_6, :class_name => "Ball"
  embeds_one :ball_7, :class_name => "Ball"
  embeds_one :ball_8, :class_name => "Ball"
  embeds_one :ball_9, :class_name => "Ball"  #总和
  embeds_one :ball_10, :class_name => "Ball" #龙虎

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
    if self.ball_9.nil?
      self.ball_9 = Ball.new
    end
    if self.ball_10.nil?
      self.ball_10 = Ball.new
    end

    ball_sum = 0

    if (balls_values.kind_of?(Hash))
      self.ball_1.set_value(balls_values[:ball_1])
      self.ball_2.set_value(balls_values[:ball_2])
      self.ball_3.set_value(balls_values[:ball_3])
      self.ball_4.set_value(balls_values[:ball_4])
      self.ball_5.set_value(balls_values[:ball_5])
      self.ball_6.set_value(balls_values[:ball_6])
      self.ball_7.set_value(balls_values[:ball_7])
      self.ball_8.set_value(balls_values[:ball_8])
      ball_sum = balls_values.inject(0) {|sum, ball| sum = sum + ball[1] }
    else
      self.ball_1.set_value(balls_values[0])
      self.ball_2.set_value(balls_values[1])
      self.ball_3.set_value(balls_values[2])
      self.ball_4.set_value(balls_values[3])
      self.ball_5.set_value(balls_values[4])
      self.ball_6.set_value(balls_values[5])
      self.ball_7.set_value(balls_values[6])
      self.ball_8.set_value(balls_values[7])
      ball_sum = balls_values.inject(0) {|sum, ball| sum = sum + ball}
    end

    self.ball_9.set_value(ball_sum, true)


    self.ball_9.dragon = self.ball_1.ball_value < self.ball_8.ball_value
    self.ball_9.tiger = !self.ball_9.dragon

  end

  def balls_to_a
    [ball_1.ball_value, ball_2.ball_value, ball_3.ball_value, ball_4.ball_value,
     ball_5.ball_value, ball_6.ball_value, ball_7.ball_value, ball_8.ball_value]
  end

end