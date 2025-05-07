Rails.application.routes.draw do
  namespace :admin do
    get 'dashboard/top'
  end
  # Devise
  devise_for :users
  devise_for :admins, skip: [:registrations], controllers: {
  sessions: 'admins/sessions'
}

  # ルートページ
  root to: "public/homes#top"

  # 一般ユーザー用
  scope module: :public do
    get 'mypage', to: 'users#mypage'
    # GitHub連携用のルーティングを追加
    get 'connect_github', to: 'users#connect_github'
    resources :users do
      resource :relationship, only: [:create, :destroy]
      # フォロー・フォロワー一覧ページのルーティングを追加
      member do
        get :followings
        get :followers
      end
      collection do
        get :search
      end
    end
    resources :posts do
      collection do
        get :search
      end
      resource :like, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end
    resources :tags, only: [:index, :show]
  end

  # ゲストログイン用ルーティングを追加
  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/guest_sessions#create', as: 'guest_sign_in'
  end

  # 管理者用
  namespace :admin do
    # 管理者のルートページはユーザー一覧
    root to: "users#index"
    
    # ユーザー管理
    resources :users, only: [:index, :show, :destroy]
    # 投稿管理
    resources :posts, only: [:index, :show, :destroy]
    
    # タグ管理
    resources :tags
  end
end