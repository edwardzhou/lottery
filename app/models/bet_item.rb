class BetItem
  include Mongoid::Document
  field :bet_time, type: Time
  field :lottery_full_id, type: String
  field :ball_no, type: Integer
  field :bet_rule_type, type: Symbol
  field :bet_rule_name, type: String
  field :bet_rule_description, type: String
  field :bet_rule_eval, type: String
  field :credit, type: BigDecimal
  field :odds, type: BigDecimal
  field :possible_win_credit, type: BigDecimal
  field :win_credit, type:BigDecimal
  field :return, type: BigDecimal
  field :total_return, type: BigDecimal
  field :is_win, type: Boolean
  field :close, type: Boolean

  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :lottery_inst
  belongs_to :user_daily_stat

  def self.get_bet_items(user, lottery_inst)
    where(user_id: user.id, lottery_inst_id: lottery_inst.id).order_by(:bet_time => "desc")
  end


end