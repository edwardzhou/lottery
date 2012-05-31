object :bet_item
attributes :_id, :bet_time, :lottery_full_id, :bet_rule_name, :credit, :odds, :possible_win_credit, :user_return, :result
node(:username) do |item|
  item.user.username
end

