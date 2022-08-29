module Api
  module V1
    class PostsController < BaseController
      def index
        @posts = @user.posts
      end
    end
  end
end
