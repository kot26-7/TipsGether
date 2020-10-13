class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :guest_login]
  before_action :correct_user, except: [:index, :show, :guest_login]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
    @posts = @posts.where(published: true) unless current_user == @user
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'ユーザー情報が更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = 'ユーザーアカウントが削除されました。'
    redirect_to root_path
  end

  def guest_login
    user = User.guest
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :introduce)
  end

  def correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user), alert: Settings.invalid_access_msg
    end
  end
end
