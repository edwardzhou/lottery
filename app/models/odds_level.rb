class OddsLevel
  include Mongoid::Document
  field :level_id, type: String
  field :level_name, type: String
  field :level_description, type: String
  field :return, type: BigDecimal
  field :level_code, type: String
  #field :lottery_def_id, type: Object
  include Mongoid::Timestamps

  embeds_many :rules
  belongs_to :lottery_def
  #embedded_in :lottery_inst

  validates :level_id, :presence => true
  validates :level_name, :presence => true
  validates :return, :numericality => true

  def rule_by_name(rule_name)
    if @rule_hash.nil?
      @rule_hash = {}
      self.rules.each {|rule| @rule_hash[rule.rule_name.to_sym] = rule}
    end

    @rule_hash[rule_name.to_sym]
  end

  def self.find_by_level_id(level_id)
    where(level_id: level_id).first
  end

  def to_s
    level_name
  end

end