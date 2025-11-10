Rails.application.routes.draw do
  devise_for :users
  root "homes#top"

  # 静的ページ
  get 'how_to_sauna', to: 'pages#how_to_sauna'
  get 'what_is_totonou', to: 'pages#what_is_totonou'

  # サウナ（投稿をネスト）
  resources :saunas, only: [:index, :show] do
    resources :posts, except: [:destroy] 
  end

  # 投稿（下書き・自分の投稿※ネスト外）
  resources :posts, only: [] do
    collection do
      get :drafts
      get :my_posts
    end
  end

  # お気に入り
  resources :favorites, only: [:index, :create, :destroy]

  # フォロー関係
  resources :relationships, only: [:create, :destroy]

  # ユーザー関連
  resources :users, only: [:show] do
    member do
      get :profile
      get 'profile/edit', to: 'users#edit_profile', as: 'edit_profile'
      patch :profile, to: 'users#update_profile'
      delete :profile, to: 'users#destroy_profile'
      get :followers
      get :followings
      get :posts, to: 'users#posts'
    end
  end

  # モラルページ（シーン）
  resources :scenes, only: [:index, :show] do
    resources :evaluations, only: [:create]
    resources :comments, only: [:create]
  end
end
