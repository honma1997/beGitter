class Public::TagsController < ApplicationController
  def index
    @tags = Tag.all.order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    @tag = Tag.find(params[:id])
    @posts = @tag.posts.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
  end
end