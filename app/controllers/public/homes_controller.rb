class Public::HomesController < ApplicationController
  def top
    # N+1問題解決: includes使用でuser、tagsを一括取得
    @posts = Post.includes(:user, :tags).order(created_at: :desc).limit(5)
    @users = User.order(created_at: :desc).limit(5)
  end
end