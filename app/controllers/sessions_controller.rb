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
    if @sign_user.nil? then
      redirect_to({:action => "new"}, :alert => "用户名或密码错误!")
    else
      session[:user_id] = @sign_user.id
      redirect_to gaming_path("ball1")
    end
  end

  def logout
    session.clear
    redirect_to :action => :new
  end
end
