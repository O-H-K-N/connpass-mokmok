Rails.application.routes.draw do
  root 'homes#top'
  get 'top', to: 'homes#top'
  get 'login', to: 'users#login'
  post '/callback' => 'linebot#callback'
  resource :user, only: %i[show create]
end
