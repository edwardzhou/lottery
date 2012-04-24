class Rule
  include Mongoid::Document
  include Mongoid::Timestamps

  field :rule_name, type: String
  field :rule_title, type: String
  field :rule_description, type: String
  field :odds, type: BigDecimal
  field :eval_expr, type: String
  field :active, type: Boolean

  belongs_to :game
end