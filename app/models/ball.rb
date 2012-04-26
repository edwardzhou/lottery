class Ball
  include Mongoid::Document
  include Mongoid::Timestamps

  field :ball_name, type: String
  field :ball_no, type: Integer
  field :odds, type: BigDecimal
  field :ball_value, type: Integer
  embeds_many :rules
  embedded_in :game


end