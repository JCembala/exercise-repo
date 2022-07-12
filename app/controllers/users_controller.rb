class UsersController < ApplicationController
  def index
    @q = User.where(admin: false).ransack(params[:q])
    @users = @q.result
  end

  def follow
    @user = User.find(params[:id])
    current_user.followees << @user
    redirect_back(fallback_location: root_path)
  end

  def unfollow
    @user = User.find(params[:id])
    current_user.followed_users.find_by(followed_id: @user.id).destroy
    redirect_back(fallback_location: root_path)
  end
end
