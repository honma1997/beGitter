class Admin::ApplicationController < ApplicationController
  # 管理者認証が必要
  before_action :authenticate_admin!
  
  # 管理者用レイアウトを使用
  layout 'admin'
  
  private
  
  # 管理者認証メソッド
  def authenticate_admin!
    unless admin_signed_in?
      redirect_to new_admin_session_path, alert: "管理者権限が必要です"
    end
  end
end