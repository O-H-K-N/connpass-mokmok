Rails.application.routes.draw do
  root 'homes#top'
  get 'top', to: 'homes#top'
  get 'login', to: 'users#login'
  post '/callback' => 'linebot#callback'
  resources :users, only: %i[show create]
  resources :connpass, only: %i[new update]
end
