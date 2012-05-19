class Admin::LotteryDefsController < Admin::AdminBaseController

  def index
    @lottery_defs = LotteryDef.all
  end

  def show
    @lottery_def = LotteryDef.find(params[:id])
  end

  def update
    @lottery_def = LotteryDef.find(params[:id])

    @lottery_def.return_rate = params[:lottery_def][:return_rate].to_i

    @lottery_def.odds_levels.each do |odds_level|
      odds_level.return = params["odds_level_#{odds_level.id}".to_sym][:return]
      odds_level.rules.each do |rule|
        rule.odds = params["rule_#{rule.id}".to_sym][:odds]
        rule.active = params["rule_#{rule.id}".to_sym][:active]
      end
      #odds_level.save!
    end

    @lottery_def.save!

    redirect_to :action => "show"
  end

end
