class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    current_user.favorites.create(post_id: params[:post_id])
    respond_to do |format|
      format.html { redirect_to post_path(@post) }
      format.js
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    Favorite.find_by(post_id: params[:post_id], user_id: current_user.id).destroy
    respond_to do |format|
      format.html { redirect_to post_path(@post) }
      format.js
    end
  end
end
