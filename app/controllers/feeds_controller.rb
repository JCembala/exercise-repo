class FeedsController < ApplicationController
  def index
    followees = current_user.followees
    @posts = Post.where(user_id: followees).page params[:page]
  end
end
