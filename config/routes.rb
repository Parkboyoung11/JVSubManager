Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "sessions#new"
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    resources :admins
    get "/signup",  to: "users#create"
    post "/signin", to: "users#signin"
    get "/active_account", to: "users#activeAccount", as: "active_account"
  end
end
