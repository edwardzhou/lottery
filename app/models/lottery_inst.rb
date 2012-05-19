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


end