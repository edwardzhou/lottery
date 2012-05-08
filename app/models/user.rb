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
  include Mongoid::Timestamps

  attr_accessible :username, :password, :password_confirmation, :true_name, :phone

  has_secure_password

  def self.sign_in(username, password)
    where(username: username.downcase).and(locked: false).first.try(:authenticate, password)
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