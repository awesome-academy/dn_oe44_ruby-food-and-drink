Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resource :carts, except: [:new, :edit]
    resources :users, only: :show
    resources :products, only: :show
    resources :orders, only: [:show, :new, :create]
    end
end
