class User
  include Mongoid::Document
  field :username, type: String
  field :password, type: String
  field :salt, type: String
  field :true_name, type: String
  field :telephone, type: String
  field :last_login_at, type: DateTime
  field :last_login_ip, type: String
  field :locked, type: Boolean
  field :locked_at, type: DateTime
  include Mongoid::Timestamps

end