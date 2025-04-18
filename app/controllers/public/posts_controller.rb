class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :search]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  
  # 投稿一覧
  def index
    @posts = Post.includes(:user, :tags).order(created_at: :desc).page(params[:page]).per(10)
    @tags = Tag.all # 検索フォーム用
    @users = User.all # ユーザー一覧を追加
    @selected_user_id = params[:user_id] # 選択されたユーザーIDを追加
  end

  # 投稿詳細
  def show
    @comment = Comment.new
  end

  # 新規投稿フォーム
  def new
    @post = Post.new
    @tags = Tag.all
  end

  # 投稿作成処理
  def create
    @post = current_user.posts.new(post_params)
    
    if @post.save
      redirect_to post_path(@post), notice: "投稿が完了しました"
    else
      @tags = Tag.all
      render :new
    end
  end

  # 投稿編集フォーム
  def edit
    @tags = Tag.all
    @selected_tag_ids = @post.tags.pluck(:id)
  end

  # 投稿更新処理
  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "投稿を更新しました"
    else
      @tags = Tag.all
      @selected_tag_ids = params[:post][:tag_ids] || []
      render :edit
    end
  end
  
  # 投稿削除処理
  def destroy
    if @post.destroy
      redirect_to posts_path, notice: "投稿を削除しました"
    else
      flash[:alert] = "投稿の削除に失敗しました"
      redirect_to post_path(@post)
    end
  end

  # 投稿検索処理
  def search
    @keyword = params[:keyword]
    @tags = Tag.all # 検索フォーム用
    @users = User.all # ユーザー一覧を追加
    @selected_user_id = params[:user_id] # 選択されたユーザーIDを追加
    
    begin
      # tag_ids パラメータの処理
      tag_param = params[:tag_ids]
      @selected_tag_ids = case tag_param
                          when Array
                            tag_param.compact.reject(&:blank?)
                          when String
                            [tag_param].reject(&:blank?)
                          else
                            []
                          end
      
      @posts = Post.includes(:user, :tags)
                  .search(@keyword, @selected_tag_ids)
                  .order(created_at: :desc)
                  .page(params[:page])
                  .per(10)
                  
      # ユーザーIDによるフィルタリングを追加
      if @selected_user_id.present?
        @posts = @posts.where(user_id: @selected_user_id)
      end
    rescue => e
      Rails.logger.error "検索エラー: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      @posts = Post.none
      flash.now[:alert] = "検索処理中にエラーが発生しました。管理者にお問い合わせください。"
    end
    
    render :index
  end
  
  private
  
  # 投稿を取得するメソッド
  def set_post
    @post = Post.find_by(id: params[:id])
    unless @post
      redirect_to posts_path, alert: "その投稿はすでに削除されています。"
    end
  end

  # 投稿者本人かチェックするメソッド
  def ensure_correct_user
    unless @post.user == current_user
      redirect_to posts_path, alert: "他のユーザーの投稿は編集・削除できません"
    end
  end
  
  # ストロングパラメータ
  def post_params
    params.require(:post).permit(:title, :body, :image, tag_ids: [])
  end
end