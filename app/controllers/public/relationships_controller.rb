class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  # フォロー作成アクション
  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    redirect_to user_path(@user), notice: "#{@user.name}さんをフォローしました"
  end

  # フォロー解除アクション
  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
    redirect_to user_path(@user), notice: "#{@user.name}さんのフォローを解除しました"
  end
end