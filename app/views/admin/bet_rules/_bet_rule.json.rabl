object :bet_rule
attributes :_id, :rule_id, :rule_name, :odds_type, :sort_index


node(:edit_url) do |bet_rule|
  link_to "修改", edit_admin_bet_rule_path(bet_rule), :remote => true
end

node(:delete_url) do |bet_rule|
  link_to "删除", admin_bet_rule_path(bet_rule), :method => :delete, :confirm => "Are you sure?", :remote => true
end

