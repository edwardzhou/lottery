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
end