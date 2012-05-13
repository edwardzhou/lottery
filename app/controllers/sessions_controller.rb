#encoding: utf-8

class SessionsController < ApplicationController
  layout false

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @sign_user = User.sign_in(@user.username, @user.password)
    if @sign_user.nil? then
      redirect_to({:action => "new"}, :alert => "用户名或密码错误!")
    else
      redirect_to gaming_path("ball1")
    end
  end
end
