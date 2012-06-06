object @odds_level

attributes :level_name, :level_description, :return
node(:can_bet) do
  @lottery.accept_betting
end

child(@lottery => :current_lottery) do
  attributes :lottery_full_id, :start_time, :end_time, :close_at
end

child(current_user => :user) do
  attributes :total_credit, :available_credit
end

child(@previous_lottery => :previous_lottery) do
  attributes :lottery_full_id
  #node(:balls) {|pl| pl.balls_to_a}
  node(:ball_1) {|p| format("%02d", p.ball_1.ball_value)}
  node(:ball_2) {|p| format("%02d", p.ball_2.ball_value)}
  node(:ball_3) {|p| format("%02d", p.ball_3.ball_value)}
  node(:ball_4) {|p| format("%02d", p.ball_4.ball_value)}
  node(:ball_5) {|p| format("%02d", p.ball_5.ball_value)}
  node(:ball_6) {|p| format("%02d", p.ball_6.ball_value)}
  node(:ball_7) {|p| format("%02d", p.ball_7.ball_value)}
  node(:ball_8) {|p| format("%02d", p.ball_8.ball_value)}
end

child(@current_daily_stat => :stat) do
  attributes :total_win_after_return
end


child :rules do
  attributes :rule_name, :rule_title, :rule_description, :odds
end