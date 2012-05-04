object @odds_level

attributes :level_name, :level_description, :return

child :rules do
  attributes :rule_name, :rule_title, :rule_description, :odds
end