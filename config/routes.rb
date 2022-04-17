Rails.application.routes.draw do
  root 'homes#top'
  get 'login', to: 'users#login'
  post '/callback' => 'linebot#callback'
  resources :users, only: [:new, :create]
end
