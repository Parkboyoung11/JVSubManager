Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "sessions#new"
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    resources :admins
    post "/signup",  to: "users#create"
    post "/signin", to: "users#signin"
    get "/active_account", to: "users#activeAccount", as: "active_account"
    get "/list", to: "movies#getAnimeList"
    get "/addToMovie", to: "movies#createDB"
    get "/like", to: "movies#favoriteHanding"
    get "/favorite", to: "movies#getFavoriteList"
    get "/more", to: "movies#getMoreList"
  end
end
