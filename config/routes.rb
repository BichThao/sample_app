Rails.application.routes.draw do
  root "static_pages#home"
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  delete "/logout", to: "sessions#destroy"
  post "/microposts", to: "microposts#create"
  delete "microposts", to: "microposts#destroy"
  
  resources :users
  resources :account_activations, only: :edit
  resources :password_resets, except: [:show, :destroy]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:index, :create, :destroy]
end
