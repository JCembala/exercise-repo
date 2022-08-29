class PostsController < BaseController
  before_action :set_post, only: %i[show destroy edit update]

  def index
    @posts = Post.where(user: current_user).page params[:page]
  end

  def new
    @post = Post.new
  end

  def create
    if form_post.save
      redirect_to posts_path, notice: t('post.created')
    else
      flash.now[:alert] = t('post.not_created')
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit
    authorize(@post)
  end

  def destroy
    authorize(@post)
    @post.destroy

    redirect_to posts_url, notice: t('post.destroyed')
  end

  def update
    authorize(@post)
    form = PostForm.new(@post, params[:post])

    if form.save
      redirect_to posts_path, notice: t('post.updated')
    else
      flash.now[:alert] = t('post.not_updated')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = current_user.posts.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path, status: :unauthorized
  end

  def form_post
    @post = Post.new

    PostForm.new(
      @post,
      title: params[:post][:title],
      content: params[:post][:content],
      user_id: current_user.id
    )
  end
end
