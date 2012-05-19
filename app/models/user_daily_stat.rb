class UserDailyStat
  include Mongoid::Document

  field :stat_date, type: Time
  field :total_win, type: BigDecimal, default: 0
  field :total_return, type: BigDecimal, default: 0

  belongs_to :user
  has_many :bet_item

  def self.get_current_stat(user, the_date = Date.today)
    the_date = the_date.to_time.beginning_of_day
    user_stat = self.find_or_create_by({user_id: user.id, stat_date: the_date})
  end

end