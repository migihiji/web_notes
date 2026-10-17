class PagesController < ApplicationController
  def hello
    @message = "データベースから記事を取得しました！"

    @articles = Article.order(created_at: :desc)
  end
end
