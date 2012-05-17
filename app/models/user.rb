class User

  include Mongoid::Document
  include ActiveModel::SecurePassword

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
  field :user_role, type: String

  include Mongoid::Timestamps

  has_secure_password


  attr_accessible :username, :password, :password_confirmation,
                  :true_name, :phone, :checkcode, :total_credit,
                  :available_credit, :odds_level

  attr_accessor :checkcode

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

  scope :active_users, excludes(locked: true)
  scope :locked_users, where(locked: true)


  def self.sign_in(username, password)
    user = where(username: username.downcase).excludes(locked: true).first
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


end
