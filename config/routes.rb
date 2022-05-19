Rails.application.routes.draw do
  root 'homes#top'
  get 'top', to: 'homes#top'
  get 'use', to: 'homes#use'
  get 'privasy', to: 'homes#privasy'
  get 'terms', to: 'homes#terms'
  get 'contact', to: 'homes#contact'
  get 'login', to: 'users#login'
  get 'set', to: 'users#set'
  post '/callback' => 'linebot#callback'
  resources :users, only: %i[index show edit create update]
  resources :connpass, only: %i[new update]
end
