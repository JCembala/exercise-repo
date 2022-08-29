class UsersController < BaseController
  def index
    @q = User.includes(:followers).where(admin: false).ransack(params[:q])
    @users = @q.result
  end
end
