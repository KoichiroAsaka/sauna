Rails.application.routes.draw do
  get 'pages/how_to_sauna'
  devise_for :users
  root "homes#top"

  # ✅ サウナごとの投稿
  resources :saunas, only: [:index, :show] do
    resources :posts, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  end

  # ✅ 下書き一覧、自分の投稿一覧（ネスト外）
  resources :posts, only: [] do
    collection do
      get :drafts
      get :my_posts
    end
  end

  # お気に入り一覧（ネスト外）
  resources :favorites, only: [:index, :create, :destroy]

  # フォロー／フォロワー関係
  resources :relationships, only: [:create, :destroy]

  # マイページ／プロフィール
  resources :users, only: [:show] do
    member do
      get 'profile'
      get 'profile/edit', to: 'users#edit_profile', as: 'edit_profile'
      patch 'profile', to: 'users#update_profile'
      delete 'profile', to: 'users#destroy_profile'
      get 'followers'
      get 'followings'
    end
  end

  #静的ページ（How to sauna）
  get 'how_to_sauna', to: 'pages#how_to_sauna'

end
