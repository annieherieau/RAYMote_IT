Rails.application.routes.draw do
  resources :tags
  resources :orders

  devise_for :users

  resources :workshops do
    resource :like, only: [:create, :destroy], controller: 'likes'
    resources :attendances, only: [:create, :destroy]  # Ajouter cette ligne
  end

  resources :tags, only: [:show]
  
  resources :users, only: [:index, :show], path: 'profile'

  #resource :profile, controller: 'users', only: [:show], path: 'profile'

  # Stripe
  scope '/checkout' do
    post 'create', to: 'checkout#create', as: 'new_checkout_create'
    get 'success', to: 'checkout#success', as: 'checkout_success'
    get 'cancel', to: 'checkout#cancel', as: 'checkout_cancel'
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "workshops#index"
end
