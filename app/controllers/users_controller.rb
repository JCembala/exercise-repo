class UsersController < ApplicationController
  def index
    @q = User.where(admin: false).ransack(params[:q])
    @users = @q.result
  end
end
