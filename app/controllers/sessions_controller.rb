#encoding: utf-8

class SessionsController < ApplicationController
  layout false
  skip_before_filter :login_required

  def new
    session[:user_id] = nil
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @sign_user = User.sign_in(@user.username, @user.password)

    alert = nil
    if @sign_user.nil? then
      alert = t("message.login.account_wrong")
    elsif @sign_user.locked?
      alert = t("message.login.account_locked")
    elsif @sign_user.is_user? and @sign_user.agent.locked?
      alert = t("message.login.account_agent_locked")
    end

    if alert.nil?
      @sign_user.last_login_at = Time.now
      @sign_user.last_login_ip = self.request.remote_ip
      @sign_user.save!
      session[:user_id] = @sign_user.id
      if @sign_user.is_admin?
        redirect_to admin_users_path
      elsif @sign_user.is_agent?
        redirect_to agent_users_path
      else
        redirect_to agreement_home_index_path
      end
    else
      redirect_to({:action => "new"}, :alert => alert)
    end
  end

  def logout
    reset_session
    redirect_to :action => :new
  end
end
