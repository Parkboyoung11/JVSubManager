Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "sessions#new"
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    get "logout", to: "sessions#destroy", as: "logout"
    get "/home", to: "admins#show", as: "home"
    post "/signup",  to: "users#create"
    post "/signin", to: "users#signin"
    post "/changepassword", to: "users#changepassword"
    get "/active_account", to: "users#activeAccount", as: "active_account"
    get "/list", to: "movies#getAnimeList"
    get "/like", to: "movies#favoriteHanding"
    get "/favorite", to: "movies#getFavoriteList"
    get "/more", to: "movies#getMoreList"
    get "/episodes", to: "episodes#getEpisodes"
    get "/addToEpisode", to: "episodes#createEpisode"
    get "/search", to: "movies#searchAnime"
    get "/watching", to: "episodes#setWatchedTime"
    resources :admins, only: [:update, :edit]
    scope "/admin" do
      resources :users, only: [:update, :index]
      resources :movies, only: [:new, :create, :update, :index, :edit, :destroy] do
        resources :episodes, only: [:new, :index, :edit]
      end
    end
    resources :episodes, only: [:update, :destroy, :create]
  end
end
