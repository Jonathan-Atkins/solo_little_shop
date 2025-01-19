Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Merchants
  #verb namespace/namespace/endpoint, to: folder/folder/controller#controller_action
  get "/api/v1/merchants/find",      to: "api/v1/merchants/search#show"
  get "/api/v1/merchants",           to: "api/v1/merchants#index"
  post "/api/v1/merchants",          to: "api/v1/merchants#create" 
  patch "/api/v1/merchants/:id",     to: "api/v1/merchants#update"
  delete "/api/v1/merchants/:id",    to: "api/v1/merchants#destroy"
  get "/api/v1/merchants/:id/items", to: "api/v1/merchants/items#index"
  get "/api/v1/merchants/:id",       to: "api/v1/merchants#show"

  # Items
  get "/api/v1/items/:id/merchant",      to: "api/v1/items#find_merchant"
  get "/api/v1/items/find_all",          to: "api/v1/items/search#show"
  get "/api/v1/items",                   to: "api/v1/items#index"
  get "/api/v1/items/:id",               to: "api/v1/items#show"
  post "/api/v1/items",                  to: "api/v1/items#create"
  put "/api/v1/items/:id",               to: "api/v1/items#update"
  delete "/api/v1/items/:id",            to: "api/v1/items#destroy"

  # Invoices
  get "api/v1/merchants/:merchant_id/invoices", to: "api/v1/invoices#index"

  # Customers
  get "/api/v1/merchants/:merchant_id/customers", to: "api/v1/merchants/customers#customers_by_merchant"
  
  #MerchantCoupons
  namespace :api do
    namespace :v1 do
      resources :merchants do
        resources :coupons, only: [:index, :show], module: :merchants
      end
    end
  end

  #Coupons
  namespace :api do
    namespace :v1 do
      resources :merchants do
        resources :coupons, only: [:show]
      end
    end
  end
end
