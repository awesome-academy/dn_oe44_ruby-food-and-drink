Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resource :carts, except: [:new, :edit]
    resources :users, only: :show
    resources :products, only: :show
    resources :orders, except: [:index, :update, :destroy]
    namespace :admin do
      root "dashboard#index"
      resources :orders, only: :index
    end
  end
end
