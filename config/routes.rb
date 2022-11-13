require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations], controllers: { 
    registrations: 'registrations',
    confirmations: 'confirmations',
    omniauth_callbacks: 'omniauth_callbacks'
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
      resources :imports, only: [:index, :new, :create]
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
      resources :feed_exports, only: [:index, :create]
    end

    namespace :api do
      namespace :v1 do
        defaults format: :json do
          resources :posts, only: [:index, :show, :create, :update, :destroy]
        end
      end
    end
  end

  # Basic auth for accessing RACK apps: https://blog.arkency.com/common-authentication-for-mounted-rack-apps-in-rails/
  with_dev_auth =
  lambda do |app|
    Rack::Builder.new do
      use Rack::Auth::Basic do |username, password|
        ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV.fetch("DEV_USERNAME"))) &
          ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV.fetch("DEV_PASSWORD")))
      end
      run app
    end
  end

mount with_dev_auth.call(Sidekiq::Web), at: "sidekiq"
end
