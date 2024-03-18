Rails.application.routes.draw do
  resources :orders
  devise_for :users

  resources :workshops do
    member do
      post 'like'
      delete 'dislike'
    end
  end

  resources :users, only: [:index, :show], path: 'profile'

  #resource :profile, controller: 'users', only: [:show], path: 'profile'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "workshops#index"
end
