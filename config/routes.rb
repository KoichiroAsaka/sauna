Rails.application.routes.draw do
  get 'users/show'
  devise_for :users
  root "homes#top"      # トップページをルートに設定
  resources :saunas, only: [:index, :show]
  resources :posts
  resources :users, only: [:show]  # マイページ用
end
