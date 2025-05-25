class Admin::CommentsController < Admin::ApplicationController
  before_action :set_comment, only: [:destroy]
  
  def destroy
    @post = @comment.post
    
    if @comment.destroy
      redirect_to admin_post_path(@post), notice: "コメントを削除しました"
    else
      redirect_to admin_post_path(@post), alert: "コメントの削除に失敗しました"
    end
  end
  
  private
  
  def set_comment
    @comment = Comment.find(params[:id])
  end
end