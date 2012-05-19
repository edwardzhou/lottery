class UserdailyStat
  include Mongoid::Document

  field :stat_date, type: Date
  field :total_win, type: BigDecimal
  field :total_return, type: BigDecimal

  belongs_to :user
  has_many :bet_item

end