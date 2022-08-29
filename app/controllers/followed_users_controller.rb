class FollowedUsersController < BaseController
  def index
    @followees = current_user.followees
  end
end
