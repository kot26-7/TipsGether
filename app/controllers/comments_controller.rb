class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find(params[:post_id])
    @comments = post.comments
    @comment = @comments.build(comment_params)
    @comment.user_id = current_user.id
    unless @comment.save
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
