class Admin::OddsLevelsController < Admin::AdminBaseController

  def edit
    @lottery_def = LotteryDef.find(params[:lottery_def_id])
    @odds_level = @lottery_def.odds_levels.find(params[:id])
  end

  def update
    @lottery_def = LotteryDef.find(params[:lottery_def_id])
    @odds_level = @lottery_def.odds_levels.find(params[:id])
    logger.debug("before update, return => #{@odds_level.return}")
    @odds_level.return = params[:odds_level][:return]
    logger.debug("after update, return => #{@odds_level.return}")

    @odds_level.rules.each do |rule|
      logger.debug("before update, rule[id=> #{rule.id}, name=> #{rule.rule_name}] odds => #{rule.odds}")
      rule.odds = params["rule_#{rule.id}".to_sym][:odds]
      rule.active = params["rule_#{rule.id}".to_sym][:active]
      logger.debug("after update, rule[id=> #{rule.id}, name=> #{rule.rule_name}] odds => #{rule.odds}")
    end

    #@odds_level.save!
    @lottery_def.save!

    respond_to do |format|
      format.html {redirect_to edit_admin_lottery_def_odds_level_path(@lottery_def, @odds_level)}
    end

  end


end
