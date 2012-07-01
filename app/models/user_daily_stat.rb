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
  belongs_to :top_user,:class_name => "User", :foreign_key => "top_user_id"
  has_many :bet_items

  scope :recent, lambda {|user| where(:user_id => user.id).and(:stat_date.gte => 30.days.ago.beginning_of_day).order_by(:stat_date => :asc) }
  scope :recent_2weeks, lambda {|user| where(:user_id => user.id).and(:stat_date.gte => DateTime.now.prev_week).order_by(:stat_date => :asc) }
  scope :latest, lambda {|user| where(:user_id => user.id).order_by(:stat_date => :desc).limit(1) }
  scope :by_date, lambda {|the_date| where(:stat_date => the_date)}
  scope :by_agent, lambda {|user| where(:agent_id => user.id) }
  scope :by_top_user, lambda {|user| where(:top_user_id => user.id) }
  scope :agents_by_top_user, lambda {|user| where({:agent_id => user.id}) }

  def self.get_current_stat(user, the_date = Date.today)
    the_date = the_date.to_time.beginning_of_day
    user_stat = self.find_or_create_by({user_id: user.id, stat_date: the_date})
  end


  def formatted_start_date
    I18n.l(self.stat_date, :format => "%m-%d %A")
  end

end