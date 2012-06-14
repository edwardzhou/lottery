namespace :lottery do
  #require "#{Rails.root}/app/models/lottery_config"
  task :process => :environment do
    #current_lottery = LotteryConfig.first.lottery_inst
    #p current_lottery
    require "lottery_task"
    require "calculation"
    Calculation.load_predict_lottery
    LotteryTask.new.lottery_process
  end

  task :reset_available_credits => :environment do
    require "lottery_task"
    require "calculation"
    LotteryTask.reset_available_credits
  end
end