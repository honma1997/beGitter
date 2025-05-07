class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  # 既存のafter_sign_in_path_forメソッドはそのまま維持
  def after_sign_in_path_for(resource)
    if resource.is_a?(Admin)
      admin_users_path  # 管理者用ダッシュボードや一覧など好きな場所に変更してOK
    else
      root_path  # 一般ユーザーのトップページ
    end
  end

  # MarkdownHelperを全コントローラーで使えるようにする
  helper :all

  # ゲストユーザー用の共通チェックメソッド
  def check_guest_user
    if user_signed_in? && current_user.guest?
      redirect_to request.referer || root_path, alert: "ゲストユーザーはこの機能を使用できません。実際に使用するには新規登録をお願いします。"
    end
  end
  
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phase, :github_username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phase, :github_username])
  end
  
end