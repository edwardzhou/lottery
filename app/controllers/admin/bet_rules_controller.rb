class Admin::BetRulesController < Admin::AdminBaseController

  before_filter :init

  def index
    @bet_rules = @lottery_def.bet_rules

    filter = params[:filter]
    filter = Regexp.new(filter, true) if filter

    @bet_rules = @bet_rules.where(:username => filter).or(:true_name => filter).or(:phone => filter) if filter
    @total_rows = @bet_rules.dup.count
    rows_per_page = params[:rows] || 20
    @page = params[:page].to_i
    @pages = (@total_rows / rows_per_page.to_f).ceil

    @page = @pages if @page > @pages

    if request.xhr?
      @bet_rules = @bet_rules.order_by(params[:sidx].to_sym => params[:sord].to_sym).paginate(:page => params[:page], :per_page => rows_per_page)
      #@bet_rules.paginate(:page => params[:page], :per_page => rows_per_page)
    end
  end

  def new
    @bet_rule = BetRule.new
  end

  def edit
    @bet_rule = @lottery_def.bet_rules.find(params[:id])
  end

  def create
    @bet_rule = @lottery_def.bet_rules.build(params[:bet_rule])
    @lottery_def.save!
  end

  def update
    @bet_rule = @lottery_def.bet_rules.find(params[:id])
    @bet_rule.update_attributes!(params[:bet_rule])
  end

  def destroy
    @bet_rule = @lottery_def.bet_rules.find(params[:id])
    @lottery_def.bet_rules.delete (@bet_rule)
    @lottery_def.save!
  end

  private
  def init
    @lottery_def = LotteryDef.first
  end

end
