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

  attr_accessible :username, :password, :password_confirmation, :true_name, :phone, :checkcode
  attr_accessor :checkcode
  validates_presence_of :username

  has_secure_password

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
