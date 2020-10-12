class UsersController < ApplicationController
  def index
  end

  def show
  end

  def edit
  end

  def guest_login
    user = User.guest
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end
end
