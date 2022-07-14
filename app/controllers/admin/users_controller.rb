module Admin
  class UsersController < ApplicationController
    def index
      authorize [:admin, User]
      @users = User.all
    end

    def update
      authorize [:admin, User]
      @user = User.find(params[:id])
      form = UserForm.new(@user, params[:user])

      if form.save
        redirect_to admin_users_path, notice: t('user.updated')
      else
        flash.now[:alert] = t('user.not_updated')
        render :edit, status: :unprocessable_entity
      end
    end

    def edit
      authorize [:admin, User]
      @user = User.find(params[:id])
    end
  end
end
