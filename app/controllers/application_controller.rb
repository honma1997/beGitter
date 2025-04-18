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
  
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phase])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phase])
  end
end