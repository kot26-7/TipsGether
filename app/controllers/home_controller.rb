class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:search]

  def index
  end

  def search
    option = params[:option]
    keyword = params[:keyword]
    @err_msg = ''
    @results_u = ''
    @results_p = ''
    if option.blank?
      redirect_to root_path, alert: 'エラーが発生しました。再度検索を行ってください。'
    elsif keyword.blank?
      @err_msg = 'キーワードが設定されていません。再度検索を行ってください。'
    else
      # 検索結果の処理
      if option == '2'
        @results_u = User.search(keyword)
      elsif option == '3'
        @results_p = Post.search(keyword)
      elsif option == '1'
        # 検索結果の例外処理
        @err_msg = '検索対象が設定されていません。再度お試しください。'
      end
    end
  end
end
