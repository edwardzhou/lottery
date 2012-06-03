namespace :Lottery do
  #require "models/lottery_config"
  task :process do
    current_lottery = LotteryConfig.first.lottery_inst
    p current_lottery
  end
end