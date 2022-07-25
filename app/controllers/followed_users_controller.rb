class FollowedUsersController < ApplicationController
  def index
    @followees = current_user.followees
  end
end
