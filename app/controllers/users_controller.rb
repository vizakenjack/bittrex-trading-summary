class UsersController < ApplicationController
  def index
    @users = User.where("id > ?", 0).all
  end

  def show
    @user = User.find params[:id]
  end
end
