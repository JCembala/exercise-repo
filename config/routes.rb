Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  devise_scope :user do
    authenticated :user do
      root 'users#index', as: :authenticated_root
      get '/users/sign_out', to: 'devise/sessions#destroy'
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end

    resource :admin
    namespace :admin do
      resources :users
    end

    root to: 'users#index'
    get '/users', to: 'users#index'

    post '/users/:id/follow', to: 'follows#create', as: 'follow_user'
    post '/users/:id/unfollow', to: 'follows#destroy', as: 'unfollow_user'
  end
end
