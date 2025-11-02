Rails.application.routes.draw do
  devise_for :users
  root "homes#top"

  # ✅ サウナごとの投稿
  resources :saunas, only: [:index, :show] do
    resources :posts, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  end

  # ✅ 下書き一覧（ネスト外）
  resources :posts, only: [] do
    collection do
      get :drafts
    end
  end

  # ✅ マイページ／プロフィール
  resources :users, only: [:show] do
    member do
      get 'profile'
      get 'profile/edit', to: 'users#edit_profile', as: 'edit_profile'
      patch 'profile', to: 'users#update_profile'
    end
  end
end
