class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    session[:session_views] ||= 0
    article = Article.find(params[:id])
    if article
      if session[:session_views] < 3
        session[:session_views] += 1
        render json: article
      else
        render json: {error: "View Limit Reached"}, status: :unauthorized
      end
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
