class Game
  include Mongoid::Document
  include Mongoid::Timestamps

  field :game_name, type: String
  field :start_time, type: Time
  field :end_time, type: Time
  field :active, type: Boolean
  field :total_bonus, type: Integer
  field :description, type: String

  has_many :rules

end