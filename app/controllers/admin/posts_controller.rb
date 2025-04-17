# app/controllers/admin/posts_controller.rb
class Admin::PostsController < Admin::ApplicationController
  # 投稿一覧
  def index
    @keyword = params[:keyword]
    @posts = if @keyword.present?
              Post.includes(:user, :tags).where('title LIKE ? OR body LIKE ?', "%#{@keyword}%", "%#{@keyword}%")
            else
              Post.includes(:user, :tags)
            end
    
    @posts = @posts.order(created_at: :desc).page(params[:page]).per(20)
  end

  # 投稿詳細
  def show
    @post = Post.includes(:user, :comments, :likes).find(params[:id])
  end

  # 投稿削除
  def destroy
    @post = Post.find(params[:id])
    
    if @post.destroy
      redirect_to admin_posts_path, notice: "投稿を削除しました"
    else
      redirect_to admin_posts_path, alert: "投稿の削除に失敗しました"
    end
  end
end