Rails.application.routes.draw do
  root 'homes#index'

  resources :users, only: [:new, :create]
end
