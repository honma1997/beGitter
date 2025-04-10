# app/controllers/public/users_controller.rb
class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update]
  before_action :ensure_correct_user, only: [:edit, :update]

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