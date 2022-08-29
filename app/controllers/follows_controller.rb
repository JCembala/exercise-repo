class FollowsController < BaseController
  before_action :fetch_user_data, only: [:create, :destroy]

  def create
    follow = Follow.new(follower_id: current_user.id, followed_id: @user.id)
    if follow.save
      flash[:notice] = t('user.follow_success', user_name: @user.first_name)
    else
      flash[:alert] = t('user.follow_failure', user_name: @user.first_name)
    end
    redirect_back fallback_location: root_path
  end

  def destroy
    follow = current_user.followed_users.find_by(followed_id: @user)
    if follow.destroy
      flash[:notice] = t('user.unfollow_success', user_name: @user.first_name)
    else
      flash[:alert] = t('user.unfollow_failure', user_name: @user.first_name)
    end
    redirect_back fallback_location: root_path
  end

  private

  def fetch_user_data
    @user = User.find(params[:user_id])
  end
end
