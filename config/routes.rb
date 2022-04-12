Rails.application.routes.draw do
  root 'homes#index'

  get 'login', to: 'users#login'
  resources :users, only: [:new, :create]
end
