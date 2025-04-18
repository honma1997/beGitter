class Admin::PostsController < Admin::ApplicationController
  # 投稿一覧
  def index
    @keyword = params[:keyword]
    @tags = Tag.all
    @users = User.all
    
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
      
      # 日付パラメータの処理
      @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : nil
      @end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : nil
      @selected_user_id = params[:user_id]
      
      @posts = Post.includes(:user, :tags)
                  .search(@keyword, @selected_tag_ids, @selected_user_id, @start_date, @end_date)
                  .order(created_at: :desc)
                  .page(params[:page])
                  .per(20)
    rescue => e
      Rails.logger.error "検索エラー: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      @posts = Post.none
      flash.now[:alert] = "検索処理中にエラーが発生しました。"
    end
  end

  # 投稿詳細
  def show
    @post = Post.includes(:user, :comments, :likes).find(params[:id])
  end

  # 投稿削除
  def destroy
    @post = Post.find(params[:id])
    
    if @post.destroy
      redirect_to admin_posts_path, notice: "投稿を削除しました"
    else
      redirect_to admin_posts_path, alert: "投稿の削除に失敗しました"
    end
  end
end