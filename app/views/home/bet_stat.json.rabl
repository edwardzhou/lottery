object false
node(:page) {@page}
node(:records) { @total_rows }
node(:total) { @pages }
child @user_daily_stats => :rows do
  extends "home/_bet_stat"

end
