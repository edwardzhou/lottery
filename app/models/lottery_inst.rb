class LotteryInst

  include Mongoid::Document

  field :lottery_no, type: String
  field :lottery_name, type: String
  field :start_time, type: Time
  field :end_time, type: Time
  field :period, type: Integer
  field :active, type: Boolean
  field :total_bonus, type: Integer
  field :description, type: String
  include Mongoid::Timestamps

  embeds_many :balls
  embeds_many :odds_levels

end