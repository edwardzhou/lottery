class BetItem
  include Mongoid::Document
  field :bet_time, type: Time
  field :lottery_full_id, type: String
  field :ball_no, type: Integer
  field :bet_rule_type, type: Symbol
  field :bet_rule_name, type: String
  field :bet_rule_description, type: String
  field :bet_rule_eval, type: String
  field :credit, type: BigDecimal
  field :odds, type: BigDecimal
  field :possible_win_credit, type: BigDecimal
  field :win_credit, type:BigDecimal
  field :return, type: BigDecimal
  field :total_return, type: BigDecimal
  field :result, type:BigDecimal
  field :is_win, type: Boolean
  field :close, type: Boolean

  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :agent, :class_name => "User"
  belongs_to :top_user, :class_name => "User"
  belongs_to :lottery_inst
  belongs_to :user_daily_stat

  #scope :by_user

  def self.bet_items_by_user(user, lottery_inst = nil)
    query = where(user_id: user.id)
    query = query.and(lottery_inst_id: lottery_inst.id) unless lottery_inst.nil?
    query.order_by(:bet_time => "desc")
  end

  def self.bet_items_by_admin(user, lottery_inst = nil)
    query = where(top_user_id: user.id)
    query = query.and(lottery_inst_id: lottery_inst.id) unless lottery_inst.nil?
    query.order_by(:bet_time => "desc")
  end

  def self.bet_items_by_agent(agent, lottery_inst = nil)
    query = where(agent_id: agent.id)
    query = query.and(lottery_inst_id: lottery_inst.id) unless lottery_inst.nil?
    query.order_by(:bet_time => "desc")
  end


end