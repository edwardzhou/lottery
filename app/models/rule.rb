class Rule
  include Mongoid::Document
  include Mongoid::Timestamps

  field :rule_name, type: String
  field :rule_title, type: String
  field :rule_description, type: String
  field :odds, type: BigDecimal
  field :eval_expr, type: String
  field :active, type: Boolean
  field :sort_index, type: Integer
  field :rule_group, type: String

  embedded_in :odds_level


  belongs_to :game
end