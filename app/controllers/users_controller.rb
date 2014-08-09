class UsersController < ApplicationController
  def index
    @users = User.where("id > ?", 0).all
  end

  def show
    @user = User.find params[:id]
  end

  def update_stats
    User.update_all_stats
    redirect_to users_path(notice: "Updated!")
  end
end
