class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_post_user, only: [:edit, :update, :destroy]

  def index
    @posts = Post.where(published: true).includes(:user)
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to post_path(@post), notice: '投稿しました。'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: '投稿が更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to user_path(@post.user_id), notice: '投稿が削除されました。'
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :published)
  end

  def correct_post_user
    @post = Post.find(params[:id])
    unless @post.user_id == current_user.id
      redirect_to user_path(current_user), alert: Settings.invalid_access_msg
    end
  end
end
