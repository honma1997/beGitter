Rails.application.routes.draw do
  # Devise
  devise_for :users
  devise_for :admins, skip: [:registrations]

  # ルートページ
  root to: "public/homes#top"

  # 一般ユーザー用
  scope module: :public do
    get 'mypage', to: 'users#mypage'
    resources :users do
      resource :relationship, only: [:create, :destroy]
      collection do
        get :search
      end
    end
    resources :posts do
      resource :like, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end
    resources :tags, only: [:index, :show]
  end

  # 管理者用
  namespace :admin do
    resources :users, only: [:index, :destroy]
    resources :posts, only: [:index, :destroy]
    resources :tags
  end
end
