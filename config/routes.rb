Rails.application.routes.draw do
  resources :messages
 
  resources :reviews
  
  # Page Contact
  get 'contact', to: 'static_pages#contact'
  post 'contact',  to: 'static_pages#send_contact'
  
  resources :categories
  resources :tags
  resources :orders
  
  devise_for :admins

  devise_for :users

  resources :workshops do
    resource :like, only: [:create, :destroy], controller: 'likes'
    resources :attendances, only: [:create, :destroy]
    resources :reviews, only: [:new, :create]
    member do
      patch :validate
      patch :refuse
      patch :activate
    end
  end

  get 'workshops/:id/validate', to: 'workshops#index'
  resources :tags, only: [:show]
  resources :categories, only: [:show]
  
  get 'users/:id/validate', to: 'workshops#index'
  resources :users, except: [:new, :create], path: 'profile' do
    member do
      patch :validate
    end
  end
  get 'dashboard', to: 'admins#dashboard'

  # Admin notifications
  post 'admin_notif', to: 'admins#admin_notif', as: :admin_notif

  post 'become_creator', to: 'users#become_creator', as: :become_creator
  patch 'users/:user_id/promote_to_creator', to: 'users#promote_to_creator', as: :promote_to_creator
  patch 'users/:user_id/deny_creator', to: 'users#deny_creator', as: :deny_creator

  # Stripe
  scope '/checkout' do
    post 'create', to: 'checkout#create', as: 'new_checkout_create'
    get 'success', to: 'checkout#success', as: 'checkout_success'
    get 'cancel', to: 'checkout#cancel', as: 'checkout_cancel'
  end
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "workshops#index"
end
