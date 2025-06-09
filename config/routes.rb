Rails.application.routes.draw do
  # Authentication routes
  get    'register', to: 'registrations#new'
  post   'sign_up',  to: 'registrations#create'
  get    'login',    to: 'sessions#new'
  post   'login',    to: 'sessions#create'
  delete 'logout/:id', to: 'sessions#destroy', as: 'logout'
  # API routes
  # Password management
  resource :password, only: [:edit, :update]

  # Identity management
  namespace :identity do
    resource :email,              only: [:edit, :update]
    resource :email_verification, only: [:show, :create]
    resource :password_reset,     only: [:new, :edit, :create, :update]
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root route
  root "home#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
