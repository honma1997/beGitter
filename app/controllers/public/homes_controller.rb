# app/controllers/public/homes_controller.rb
class Public::HomesController < ApplicationController
  def top
    @posts = Post.includes(:user, :tags).order(created_at: :desc).limit(5)
    @users = User.order(created_at: :desc).limit(5)
  end
end