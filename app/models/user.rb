class User

  USER = "user"
  ADMIN = "admin"
  AGENT = "agent"

  include Mongoid::Document
  include ActiveModel::SecurePassword

  before_save :update_level_name

  field :username, type: String
  field :password_digest, type: String
  #field :salt, type: String
  field :true_name, type: String
  field :phone, type: String
  field :last_login_at, type: DateTime
  field :last_login_ip, type: String
  field :locked, type: Boolean
  field :locked_at, type: DateTime
  field :total_credit, type: BigDecimal
  field :available_credit, type: BigDecimal
  field :odds_level_name, type: String
  field :return, type: BigDecimal
  field :user_role, type: String, default: "user"

  belongs_to :odds_level
  belongs_to :agent, :class_name => "User", :foreign_key => "agent_id"
  belongs_to :top_user, :class_name => "User", :foreign_key => "top_user_id"

  has_many :users, :class_name => "User", :foreign_key => "agent_id"


  include Mongoid::Timestamps

  has_secure_password


  attr_accessible :username, :password, :password_confirmation,
                  :true_name, :phone, :checkcode, :total_credit,
                  :available_credit, :odds_level, :odds_level_id

  attr_accessor :checkcode

  attr_reader :odds_level_return

  validates :username,
              :uniqueness => true,
              :presence => true,
              :length => {:minimum => 4, :maximum => 10}

  validates :password, :presence => true, :confirmation => true, :on => :create
  validates :password_confirmation, :presence => true, :on => :create
  validates :true_name, :presence => true
  validates :phone, :presence => true
  validates :total_credit, :numericality => true
  validates :available_credit, :numericality => true

  validates :odds_level, :presence => true


  scope :active_users, excludes(locked: true)
  scope :locked_users, where(locked: true)
  scope :normal_users, where(user_role: USER)


  def self.sign_in(username, password)
    user = where(username: username.downcase).first
    return nil unless user.try(:authenticate, password)
    user
  end

  def lock_account!
    unless locked?
      self.locked = true
      self.locked_at = Time.now
      save!
    end
    self
  end

  def unlock_account!
    if locked?
      self.locked = false
      self.locked_at = nil
      save!
    end
    self
  end

  def is_admin?
    ADMIN.eql?(self.user_role)
  end

  def is_agent?
    AGENT.eql?(self.user_role)
  end

  def is_user?
    USER.eql?(self.user_role)
  end

  def status
    self.locked? ? "locked" : "normal"
  end

  def odds_level_return
    odds_level.try(:return)
  end

  def reset_credit!
    self.available_credit = self.total_credit
    self.save!
    self
  end

  def self.find_by_username(username)
    where(:username => username).first
  end

  private
  def update_level_name
    self.odds_level_name = self.odds_level.level_name unless self.odds_level.nil?
  end


end
