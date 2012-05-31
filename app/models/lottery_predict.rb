require "lottery_members"

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

  include LotteryMembers


end