Rails.application.routes.draw do
  root 'homes#top'
  get 'login', to: 'users#login'
  resources :users, only: [:new, :create]
end
