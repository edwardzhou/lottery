class LotteryDef
  include Mongoid::Document

  field :lottery_name, type: String
  field :start_time, type: Time
  field :end_time, type: Time
  field :period, type: Integer
  field :active, type: Boolean
  field :return_rate, type: Integer
  field :description, type: String
  include Mongoid::Timestamps

  embeds_many :balls
  embeds_many :bet_rules
  has_many :odds_levels, :autosave => true
  has_one :lottery_config

end