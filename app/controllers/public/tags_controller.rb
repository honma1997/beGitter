class Public::TagsController < ApplicationController
  def index
    # N+1問題解決: preloadでpostsを一括取得
    @tags = Tag.preload(:posts).order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    @tag = Tag.find(params[:id])
    # N+1問題解決: includesでuser、tags、likes、commentsを一括取得
    @posts = @tag.posts.includes(:user, :tags, :likes, :comments).order(created_at: :desc).page(params[:page]).per(10)
  end
end