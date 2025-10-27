Rails.application.routes.draw do
  root "homes#top"      # トップページをルートに設定
  resources :saunas, only: [:index, :show]
  resources :posts
end
