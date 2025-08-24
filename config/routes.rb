Rails.application.routes.draw do
  # Authentication routes
  get    "register", to: "registrations#new"
  post   "sign-up",  to: "registrations#create"
  get    "login",    to: "sessions#new"
  post   "login",    to: "sessions#create"
  delete "logout/:id", to: "sessions#destroy", as: "logout"
  # API routes
  # Password management
  resource :password, only: [ :edit, :update ]
  get "reset-password", to: "identity/password_resets#new"

  # Identity management
  namespace :identity do
    resource :email,              only: [ :edit, :update ]
    resource :email_verification, only: [ :show, :create ]
    resource :password_reset,     only: [ :edit, :create, :update ]
  end

  get "settings/account", to: "user_settings#show"

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
