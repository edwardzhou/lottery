class Admin::UsersController < Admin::AdminBaseController

  def index
    filter = params[:filter]
    filter = Regexp.new(filter, true) if filter
    @users = User.all
    @users = @users.where(:username => filter) if filter
    @users = @users.order_by(params[:sidx].to_sym => params[:sord])
  end

  def lock
    @user = User.find(params[:id])
    @user.lock_account!
    redirect_to :action => "index"
  end

  def unlock
    @user = User.find(params[:id])
    @user.unlock_account!
    redirect_to :action => "index"
  end

end
