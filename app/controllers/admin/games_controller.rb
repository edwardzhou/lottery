class Admin::GamesController < Admin::AdminBaseController
  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
    @rules = @game.rules
  end
end
