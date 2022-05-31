Rails.application.routes.draw do
  devise_for :users
  root to: 'users#index'
  get '/users', to: 'users#index'
end
