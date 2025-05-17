class Public::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_guest_user
  
  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = @post.id
    
    respond_to do |format|
      if @comment.save
        format.html { redirect_to post_path(@post), notice: "コメントを投稿しました" }
        format.js   # create.js.erbを探す
      else
        format.html { redirect_to post_path(@post), alert: "コメントの投稿に失敗しました。#{@comment.errors.full_messages.join(', ')}" }
        format.js { render :error }  # error.js.erbを探す
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post
    
    if @comment.user == current_user
      @comment.destroy
      respond_to do |format|
        format.html { redirect_to post_path(@post), notice: "コメントを削除しました" }
        format.js   # destroy.js.erbを探す
      end
    else
      respond_to do |format|
        format.html { redirect_to post_path(@post), alert: "他のユーザーのコメントは削除できません" }
        format.js { render :error }
      end
    end
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:body)
  end
end