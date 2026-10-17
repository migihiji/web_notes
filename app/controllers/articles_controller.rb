
class ArticlesController < ApplicationController
  allow_unauthenticated_access only: [:index, :show]

  before_action :set_article, only: [:show]
  before_action :set_owned_article,
                only: [:edit, :update, :destroy]

  # GET /articles
  
def index
  @keyword = params[:q].to_s.strip
  @category = params[:category].to_s.strip

  @articles = Article.all

  if @keyword.present?
    escaped_keyword =
      ActiveRecord::Base.sanitize_sql_like(@keyword)

    @articles = @articles.where(
      "title LIKE ?",
      "%#{escaped_keyword}%"
    )
  end

  if @category.present?
    @articles = @articles.where(
      category: @category
    )
  end

  @articles = @articles.order(
    created_at: :desc,
    id: :desc
  )
end


  # GET /articles/:id
  def show
  end

  # GET /articles/new
  def new
    @article = Current.user.articles.build
  end

  # POST /articles
  def create
    @article = Current.user.articles.build(article_params)

    if @article.save
      redirect_to @article,
                  notice: "記事を投稿しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /articles/:id/edit
  def edit
  end

  # PATCH /articles/:id
  def update
    if @article.update(article_params)
      redirect_to @article,
                  notice: "記事を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /articles/:id
  def destroy
    @article.destroy!

    redirect_to articles_path,
                notice: "記事を削除しました。",
                status: :see_other
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def set_owned_article
    @article = Current.user.articles.find(params[:id])
  end

  def article_params
    params.expect(
      article: [:title, :category, :body]
    )
  end
end
