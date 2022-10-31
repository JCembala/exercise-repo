module Api
  module V1
    class PostsController < BaseController
      before_action :set_post, only: %i[show destroy update]

      def index
        @posts = @user.posts
      end

      def show; end

      def create
        unless form_post.save
          render json: { message: t('post.not_created') }, status: :unprocessable_entity
        end
      end

      def update
        form = PostForm.new(@post, params[:post])

        unless form.save
          render json: { message: t('post.not_updated') }, status: :unprocessable_entity
        end
      end

      def destroy
        @post.destroy

        render json: { message: 'Post was deleted' }, status: :ok
      end

      private

      def set_post
        @post = @user.posts.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Not found' }, status: :not_found
      end

      def form_post
        @post = Post.new

        PostForm.new(
          @post,
          title: params[:post][:title],
          content: params[:post][:content],
          user_id: @user.id
        )
      end
    end
  end
end
