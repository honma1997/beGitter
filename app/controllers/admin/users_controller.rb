class Admin::UsersController < Admin::ApplicationController
  # ユーザー一覧
  def index
    @users = User.all
  
    # キーワード検索
    if params[:keyword].present?
      @users = @users.where("name LIKE ? OR email LIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%")
    end
  
    # 学習フェーズ絞り込み
    if params[:phase].present?
      @users = @users.where(phase: params[:phase])
    end
  
    # ページネーション
    @users = @users.order(created_at: :desc).page(params[:page]).per(20)
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