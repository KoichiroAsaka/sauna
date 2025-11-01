Rails.application.routes.draw do
  devise_for :users
  root "homes#top"

  # サウナごとの投稿をネスト
  resources :saunas, only: [:index, :show] do
    resources :posts, only: [:index, :show, :new, :create]
  end

  # 編集・更新・削除は単体でOK（ネスト外）
  resources :posts, only: [:index, :edit, :update, :destroy]

  resources :users, only: [:show]
end
