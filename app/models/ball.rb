class Ball
  include Mongoid::Document

  field :ball_name, type: String
  field :ball_no, type: Integer
  field :odds, type: BigDecimal
  field :ball_value, type: Integer
  field :big, type: Boolean
  field :small, type: Boolean
  field :even, type: Boolean
  field :odd, type: Boolean
  field :sum_even, type: Boolean
  field :sum_odd, type: Boolean
  field :trail_big, type: Boolean
  field :trail_small, type: Boolean
  field :dragon, type: Boolean
  field :tiger, type: Boolean

  #embeds_many :rules
  embedded_in :lottery_def
  embedded_in :lottery_inst
  include Mongoid::Timestamps

  def set_value(value)
    self.ball_value = value
    self.big = value >= 11
    self.small = !self.big
    self.even = value.even?
    self.odd = !self.even
    self.sum_even = (value/10 + value%10).even?
    self.sum_odd = !self.sum_even
    self.trail_big = (value%10) >=5
    self.trail_small = !self.trail_big
  end


end