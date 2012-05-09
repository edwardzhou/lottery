class OddsLevel
  include Mongoid::Document
  field :level_name, type: String
  field :level_description, type: String
  field :return, type: BigDecimal

  embeds_many :rules
  embedded_in :lottery_def

  def rule_by_name(rule_name)
    if @rule_hash.nil?
      @rule_hash = {}
      self.rules.each {|rule| @rule_hash[rule.rule_name.to_sym] = rule}
    end

    @rule_hash[rule_name.to_sym]
  end

end