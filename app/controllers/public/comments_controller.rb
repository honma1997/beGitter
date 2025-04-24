class Public::CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = @post.id
    
    if @comment.save
      redirect_to post_path(@post), notice: "コメントを投稿しました"
    else
      # エラー処理
      redirect_to post_path(@post), alert: "コメントの投稿に失敗しました。#{@comment.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post
    
    if @comment.user == current_user
      @comment.destroy
      redirect_to post_path(@post), notice: "コメントを削除しました"
    else
      redirect_to post_path(@post), alert: "他のユーザーのコメントは削除できません"
    end
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:body)
  end
end