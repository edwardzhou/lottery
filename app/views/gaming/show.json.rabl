object @odds_level

attributes :level_name, :level_description, :return
node(:can_bet) do
  @lottery.accept_betting
end


child :rules do
  attributes :rule_name, :rule_title, :rule_description, :odds
end