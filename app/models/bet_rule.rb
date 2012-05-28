class BetRule
  include Mongoid::Document
  field :rule_id, type: Symbol
  field :rule_name, type: String
  field :odds_type, type: Symbol
  field :odds_rate, type: BigDecimal, default: 0
  field :bet_count, type: Integer, default: 0
  field :total_income, type: BigDecimal, default: 0
  field :total_outcome, type: BigDecimal, default: 0
  field :sort_index, type: Integer, default: 255
  field :groups, type: Array

  embedded_in :lottery_inst
  embedded_in :lottery_def

  include Mongoid::Timestamps
end