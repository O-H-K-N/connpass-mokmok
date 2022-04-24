Rails.application.routes.draw do
  root 'homes#top'
  get 'top', to: 'homes#top'
  get 'login', to: 'users#login'
  get 'records/login', to: 'records#login'
  post 'records/logedin', to: 'records#logedin'
  get 'letters/login', to: 'letters#login'
  post 'letters/logedin', to: 'letters#logedin'
  post '/callback' => 'linebot#callback'
  resource :user, only: %i[show create]
  resources :records, only: %i[index show new create destroy] do
    resources :comments, only: %i[index show new create destroy], shallow: true
  end
  resources :letters, only: %i[new create]
end
