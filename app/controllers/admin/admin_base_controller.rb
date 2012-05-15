class Admin::AdminBaseController < ApplicationController
  before_filter :admin_required

  layout "admin"


  private
  def admin_required
    user = User.find(session[:user_id])
    redirect_to new_sessions_path if user.nil? or not "admin".eql?(user.user_role)
  end

end
