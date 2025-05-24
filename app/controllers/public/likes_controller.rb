class Public::LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_guest_user
  before_action :set_post
  
  def create
    @like = current_user.likes.new(post_id: @post.id)
    @like.save
    # リダイレクトではなく、JavaScriptレスポンスを返す
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js   # create.js.erbを探す
    end
  end

  def destroy
    @like = current_user.likes.find_by(post_id: @post.id)
    @like.destroy
    # リダイレクトではなく、JavaScriptレスポンスを返す
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js   # destroy.js.erbを探す
    end
  end
  
  private
  
  def set_post
    # N+1問題解決: includesでlikesを一括取得
    @post = Post.includes(:likes).find(params[:post_id])
  end
end