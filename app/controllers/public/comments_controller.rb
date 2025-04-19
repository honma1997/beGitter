class Public::CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = @post.id
    
    if @comment.save
      redirect_to post_path(@post), notice: "コメントを投稿しました"
    else
      # コメント投稿失敗時は投稿詳細ページに戻る
      @comments = @post.comments.includes(:user).order(created_at: :desc)
      render 'public/posts/show'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    
    # コメント投稿者または投稿者本人のみ削除可能
    if @comment.user == current_user || @comment.post.user == current_user
      @comment.destroy
      redirect_to post_path(params[:post_id]), notice: "コメントを削除しました"
    else
      redirect_to post_path(params[:post_id]), alert: "削除権限がありません"
    end
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:body)
  end
end