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
  field :add_even, type: Boolean
  field :add_odd, type: Boolean
  field :trail_big, type: Boolean
  field :trail_small, type: Boolean
  field :dragon, type: Boolean
  field :tiger, type: Boolean
  field :east, type: Boolean
  field :south, type: Boolean
  field :west, type: Boolean
  field :north, type: Boolean
  field :middle, type: Boolean
  field :fa, type: Boolean
  field :white, type: Boolean

  #embeds_many :rules
  embedded_in :lottery_def
  embedded_in :lottery_inst
  include Mongoid::Timestamps

  def set_value(value, sum_ball = false)
    self.ball_value = value
    self.big = value >= 11
    self.big = value > 83 if sum_ball
    self.small = !self.big
    self.even = value.even?
    self.odd = !self.even
    self.add_even = (value/10 + value%10).even?
    self.add_odd = !self.add_even
    self.trail_big = (value%10) >=5
    self.trail_small = !self.trail_big

    self.east = ![1, 5, 9, 13, 17].index(value).nil?
    self.south = ![2, 6, 10, 14, 18].index(value).nil?
    self.west = ![3, 7, 11, 15, 19].index(value).nil?
    self.north = ![4, 8, 12, 16, 20].index(value).nil?
    self.middle = ![1, 2, 3, 4, 5, 6, 7].index(value).nil?
    self.fa = ![8, 9, 10, 11, 12, 13, 14].index(value).nil?
    self.white = ![15, 16, 17, 18, 19, 20].index(value).nil?
    self
  end


end