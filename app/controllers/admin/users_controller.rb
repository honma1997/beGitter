class Admin::UsersController < Admin::ApplicationController
  # ユーザー一覧
  def index
    @users = User.includes(:posts).order(created_at: :desc).page(params[:page]).per(20)
    @user_count = User.count
    @post_count = Post.count
  end

  # ユーザー詳細
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(10)
  end

  # ユーザー削除
  def destroy
    @user = User.find(params[:id])
    
    if @user.destroy
      redirect_to admin_users_path, notice: "ユーザーを削除しました"
    else
      redirect_to admin_users_path, alert: "ユーザーの削除に失敗しました"
    end
  end
end