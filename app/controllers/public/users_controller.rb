class Public::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :check_guest_user, only: [:connect_github]

  # ユーザー一覧
  def index
    # N+1問題解決: preloadでpostsとfollowersを一括取得
    @users = User.preload(:posts, :followers).page(params[:page]).per(12)
  end

  # ユーザー詳細
  def show
    @user = User.find(params[:id])
    # N+1問題解決: includesでuser、tagsを一括取得
    @posts = @user.posts.includes(:tags, :likes, :comments).order(created_at: :desc).page(params[:page]).per(5)
  end
  
  # マイページ
  def mypage
    @user = current_user
    # N+1問題解決: includesでtags、likes、commentsを一括取得
    @posts = @user.posts.includes(:tags, :likes, :comments).order(created_at: :desc).page(params[:page]).per(5)
  end

  # GitHub連携
  def connect_github
    redirect_to edit_user_path(current_user), notice: "GitHubユーザー名はプロフィール編集画面で設定できます。"
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

  def followings
    @user = User.find(params[:id])
    # N+1問題解決: preloadでpostsとfollowersを一括取得
    @users = @user.followings.preload(:posts, :followers).page(params[:page]).per(12)
    render 'followings'
  end
  
  def followers
    @user = User.find(params[:id])
    # N+1問題解決: preloadでpostsとfollowersを一括取得
    @users = @user.followers.preload(:posts, :followers).page(params[:page]).per(12)
    render 'followers'
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
    params.require(:user).permit(:name, :email, :phase, :profile_image, :github_username)
  end
  
  # ゲストユーザーかどうかをチェックするメソッド
  def check_guest
    if current_user.guest?
      redirect_to mypage_path, alert: "ゲストユーザーはプロフィール編集と退会ができません。"
    end
  end
end