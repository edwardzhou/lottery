#encoding: utf-8

require "lottery_members"

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
  field :accept_betting, type: Boolean, default: false
  field :active, type: Boolean, default: false
  field :return_rate, type: Integer
  field :total_income, type: BigDecimal
  field :total_outcome, type: BigDecimal
  field :profit, type: BigDecimal
  field :closed, type: Boolean, default: false
  field :balance_at, type: Time
  field :balanced, type: Boolean, default: false
  field :is_first, type: Boolean, default: false
  field :is_first_started, type: Boolean, default: false
  field :is_last, type: Boolean, default: false

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
  has_many :bet_items, :autosave => true

  include Mongoid::Timestamps

  scope :history, where(:balanced => true).order_by(:end_time => :desc)

  include LotteryMembers


  def formatted_end_time
    I18n.l(self.end_time, :format => "%m-%d %a %H:%M")
  end



end