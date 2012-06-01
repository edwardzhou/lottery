class UserDailyStat
  include Mongoid::Document

  field :stat_date, type: Time
  field :total_bet_credit, type: BigDecimal, default: 0
  field :total_win, type: BigDecimal, default: 0
  field :total_win_after_return, type: BigDecimal, default: 0
  field :total_return, type: BigDecimal, default: 0
  field :total_agent_return, type: BigDecimal, default: 0

  belongs_to :user
  belongs_to :agent, :class_name => "User", :foreign_key => "agent_id"
  has_many :bet_items

  scope :recent, lambda {|user| where(:user_id => user.id).and(:stat_date.gte => 30.days.ago.beginning_of_day).order_by(:stat_date => :asc) }

  def self.get_current_stat(user, the_date = Date.today)
    the_date = the_date.to_time.beginning_of_day
    user_stat = self.find_or_create_by({user_id: user.id, stat_date: the_date})
  end

  def formatted_start_date
    I18n.l(self.stat_date, :format => "%m-%d %A")
  end

end