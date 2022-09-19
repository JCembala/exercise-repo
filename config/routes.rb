Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations], controllers: { 
    registrations: 'registrations',
    confirmations: 'confirmations'
  }

    devise_scope :user do
      authenticated :user do
        root 'users#index', as: :authenticated_root
        get '/users/sign_out', to: 'devise/sessions#destroy'
        get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
        put 'users' => 'registrations#update', :as => 'user_registration'
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end

    namespace :admin do
      resources :users, only: [:index, :update, :edit, :new, :create]
    end

    root to: 'users#index'
    
    get '/users', to: 'users#index'
    resources :followed_users, only: [:index]
    resources :feeds, only: [:index]
    resources :posts

    resources :users do
      resource :follow, only: [:create, :destroy]
    end

    namespace :user do 
      resource :api_keys, only: [:update]
    end

    namespace :api do
      namespace :v1 do
        defaults format: :json do
          resources :posts, only: [:index]
        end
      end
    end
  end
end
