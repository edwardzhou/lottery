object :user_daily_stat
attributes :_id, :total_bet_credit, :total_win, :total_win_after_return, :total_return
node(:stat_date) do |uds|
  uds.formatted_start_date
end
node(:username) do |item|
  item.user.username
end

