class Admin::UsersController < Admin::AdminBaseController

  def index
    @users = User
  end

end
