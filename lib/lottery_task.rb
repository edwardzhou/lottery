require "lock_object"
require "lottery_config"
require "lottery_def"
require "lottery_inst"
require "lottery_predict"

class LotteryTask
  @@semaphore = Mutex.new

  def self.do_job(sleep_sec)
    LockObject.first.with_lock do
      sleep(sleep_sec)
    end
  end

  def self.reset_available_credits
    Rails.logger.info("[#{Time.now}] start to reset available credit")
    User.normal_users.active_users.each do |user|
      Rails.logger.info("reset #{user.username}: total_credit => #{user.total_credit}, available_credt => #{user.available_credit}")
      user.reset_credit!
    end
  end

  def lottery_process
    p "OK"

    Rails.logger.debug("lottery_process")
    while true

      lottery_conf = LotteryConfig.first
      current_lottery = lottery_conf.lottery_inst
      Rails.logger.debug("current_lottery[#{current_lottery.lottery_full_id}, accept_betting: #{current_lottery.accept_betting}, close_at: #{current_lottery.close_at}, end_time: #{current_lottery.end_time}]")
      if current_lottery.accept_betting
        if current_lottery.close_at > Time.now
          Rails.logger.debug("not close. sleep 3 secs")
          sleep(3)
        else
          Rails.logger.debug("close for betting")
          current_lottery.accept_betting = false
          current_lottery.save!
        end
      elsif not current_lottery.closed and current_lottery.close_at < Time.now
        Rails.logger.debug("close lottery")
        Calculation.close_lottery(current_lottery)
        current_lottery.active = false
        current_lottery.save!
      end

      if current_lottery.is_first and not current_lottery.is_first_started
        if current_lottery.start_time < Time.now
          current_lottery.accept_betting = true
          current_lottery.is_first_started = true
          current_lottery.save!
        end
      end

      Rails.logger.debug("current_lottery.end_time > Time.now => #{current_lottery.end_time > Time.now}")
      if current_lottery.end_time > Time.now
        sleep(3)
      else
        #if lottery_conf.next_seq_no
        Rails.logger.debug("start new lottery")
        LotteryConfig.first.start_new_lottery
      end

    end

  end

  #handle_asynchronously :lottery_process


end
