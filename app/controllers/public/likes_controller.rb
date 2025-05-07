class Public::LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_guest_user  # ゲストユーザーチェック追加
  
  def create
    @post = Post.find(params[:post_id])
    like = current_user.likes.new(post_id: @post.id)
    
    if like.save
      redirect_to request.referer, notice: "投稿にいいねしました"
    else
      redirect_to request.referer, alert: "いいねできませんでした"
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    like = current_user.likes.find_by(post_id: @post.id)
    
    if like.destroy
      redirect_to request.referer, notice: "いいねを取り消しました"
    else
      redirect_to request.referer, alert: "いいねの取り消しに失敗しました"
    end
  end
end