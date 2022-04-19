Rails.application.routes.draw do
  root 'homes#top'
  get 'login', to: 'users#login'
  get 'records/login', to: 'records#login'
  post 'records/logedin', to: 'records#logedin'
  get 'letters/login', to: 'letters#login'
  post 'letters/logedin', to: 'letters#logedin'
  post '/callback' => 'linebot#callback'
  resources :users, only: %i[new create]
  resources :records, only: %i[show new create]
  resources :letters, only: %i[new create]
end
