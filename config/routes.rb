Rails.application.routes.draw do
  root 'homes#top'
  get 'top', to: 'homes#top'
  get 'login', to: 'users#login'
  post '/callback' => 'linebot#callback'
  resource :user, only: %i[show create]
  resources :records, only: %i[index show new create destroy] do
    resources :comments, only: %i[index show new create destroy], shallow: true
  end
  resources :letters, only: %i[index show new create destroy]
  resources :tags, only: %i[show]
end
