class Public::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :ensure_correct_user, only: [:edit, :update]

  # ユーザー一覧
  def index
    @users = User.page(params[:page]).per(12)
  end

  # ユーザー詳細
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(5)
  end
  
  # マイページ
  def mypage
    @user = current_user
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(5)
  end

  # ユーザー情報編集
  def edit
  end

  # ユーザー情報更新
  def update
    if @user.update(user_params)
      redirect_to mypage_path, notice: "プロフィールを更新しました"
    else
      render :edit
    end
  end

  def destroy
    @user = current_user
    
    # ユーザーデータの削除前にログアウト処理
    sign_out(@user)
    
    # ユーザーデータの削除
    if @user.destroy
      redirect_to root_path, notice: "退会処理が完了しました。ご利用ありがとうございました。"
    else
      redirect_to edit_user_path(@user), alert: "退会処理に失敗しました。お手数ですが、管理者にお問い合わせください。"
    end
  end

  # ユーザー検索
  def search
    @users = User.where("name LIKE ?", "%#{params[:keyword]}%").page(params[:page]).per(12)
    render :index
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_correct_user
    unless @user == current_user
      redirect_to mypage_path, alert: "他のユーザーの情報は編集できません"
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :phase, :profile_image)
  end
end