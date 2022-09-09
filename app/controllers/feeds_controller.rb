class FeedsController < BaseController
  def index
    followees = current_user.followees
    @posts = Post.where(user: followees).page params[:page]
  end
end
