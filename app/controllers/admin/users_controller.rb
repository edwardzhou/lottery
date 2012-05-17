class Admin::UsersController < Admin::AdminBaseController

  def index
    filter = params[:filter]
    filter = Regexp.new(filter, true) if filter
    @users = User.all
    @users = @users.where(:username => filter).or(:true_name => filter).or(:phone => filter) if filter
    @total_rows = @users.dup.count
    rows_per_page = params[:rows] || 20
    @page = params[:page].to_i
    @pages = (@total_rows / rows_per_page.to_f).ceil

    @page = @pages if @page > @pages

    if request.xhr?
      @users = @users.order_by(params[:sidx].to_sym => params[:sord]).paginate(:page => params[:page], :per_page => rows_per_page)
      #@users.paginate(:page => params[:page], :per_page => rows_per_page)
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
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
