class BetRule
  include Mongoid::Document
  field :rule_id, type: Symbol
  field :rule_name, type: String
  field :odds_type, type: Symbol
  field :odds_rate, type: BigDecimal
  field :total_income, type: BigDecimal
  field :total_outcome, type: BigDecimal
  field :sort_index, type: Integer

  embedded_in :lottery_inst
  embedded_in :lottery_def

  include Mongoid::Timestamps
end