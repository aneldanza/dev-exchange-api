Rails.application.routes.draw do
  get "/current_user", to: "current_user#index"

  devise_for :users, path: "", path_names: {
                       sign_in: "login",
                       sign_out: "logout",
                       registration: "signup",
                     },
                     controllers: {
                       sessions: "auth/sessions",
                       registrations: "auth/registrations",
                     }

  resources :tags, only: %i[index create show] do
    get "search", on: :collection
  end

  resources :users, only: %i[index show update destroy] do
    get "search_posts"
  end

  resources :questions, only: %i[index show create update destroy]
  resources :answers, only: %i[index show create update destroy]
  resources :comments, only: %i[show create update destroy]
  resources :votes do
    post "cast_vote", on: :collection
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
