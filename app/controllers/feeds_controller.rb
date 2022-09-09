class FeedsController < BaseController
  def index
    followees = current_user.followees.pluck(:id)
    @posts = Post.where(user_id: followees).page params[:page]
  end
end
