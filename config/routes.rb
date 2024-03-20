Rails.application.routes.draw do
 
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
  end

  resources :tags, only: [:show]
  resources :categories, only: [:show]
  
  resources :users, only: [:index, :show, :destroy], path: 'profile'
  resources :admins, only: [:show]

  namespace :admin do
    resources :workshops, only: [] do
      member do
        patch :validate
      end
    end
  end

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
