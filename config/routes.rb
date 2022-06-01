Rails.application.routes.draw do
  devise_for :users

  root to: 'users#index'

  get '/users', to: 'users#index'
  
  devise_scope :user do
    authenticated :user do
      root 'users#index', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end

    get '/users/sign_out', to: 'devise/sessions#destroy'
  end
end
