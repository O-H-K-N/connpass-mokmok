Rails.application.routes.draw do
  root 'homes#top'
  get 'top', to: 'homes#top'
  get 'login', to: 'users#login'
  get '/sent' => 'records#sent'
  post '/callback' => 'linebot#callback'
  resource :user, only: %i[show create]
  resources :records, only: %i[index show new create update destroy]
  resources :letters, only: %i[index show new create destroy]
end
