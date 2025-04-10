class Admin::TagsController < Admin::ApplicationController
  before_action :set_tag, only: [:edit, :update, :destroy]
  
  # タグ一覧
  def index
    @tags = Tag.all.order(created_at: :desc).page(params[:page]).per(20)
    @tag = Tag.new  # 新規作成用
  end

  # タグ作成
  def create
    @tag = Tag.new(tag_params)
    
    if @tag.save
      redirect_to admin_tags_path, notice: "タグを作成しました"
    else
      @tags = Tag.all.order(created_at: :desc).page(params[:page]).per(20)
      render :index
    end
  end

  # タグ編集フォーム
  def edit
  end

  # タグ更新
  def update
    if @tag.update(tag_params)
      redirect_to admin_tags_path, notice: "タグを更新しました"
    else
      render :edit
    end
  end

  # タグ削除
  def destroy
    if @tag.destroy
      redirect_to admin_tags_path, notice: "タグを削除しました"
    else
      redirect_to admin_tags_path, alert: "タグの削除に失敗しました。関連する投稿がある可能性があります。"
    end
  end
  
  private
  
  # タグを取得するメソッド
  def set_tag
    @tag = Tag.find(params[:id])
  end
  
  # ストロングパラメータ
  def tag_params
    params.require(:tag).permit(:name)
  end
end