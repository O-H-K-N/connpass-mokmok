Rails.application.routes.draw do
  root 'homes#top'
  get 'login', to: 'users#login'
  get 'records/login', to: 'records#login'
  post 'records/logedin', to: 'records#logedin'
  post '/callback' => 'linebot#callback'
  resources :users, only: [:new, :create]
  resources :records, only: [:new, :create]
end
