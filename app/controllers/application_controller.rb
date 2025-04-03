class ApplicationController < ActionController::Base
   # 管理者 or ユーザーのログイン後のリダイレクト先を分岐
   def after_sign_in_path_for(resource)
    if resource.is_a?(Admin)
      admin_users_path  # 管理者用ダッシュボードや一覧など好きな場所に変更してOK
    else
      root_path  # 一般ユーザーのトップページ
    end
  end
end

