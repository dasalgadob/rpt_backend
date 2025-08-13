Rails.application.routes.draw do
  resources :products
  resources :companies do
    resources :periods
    resources :employees
    resources :dimensions
    resources :corporate_goals
    resources :departments
    resources :department_goals
    resources :positions
    resources :position_goals
    resources :position_type_weights
    resources :position_types
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
