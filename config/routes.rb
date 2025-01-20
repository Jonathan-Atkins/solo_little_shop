Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "/api/v1/merchants/find",      to: "api/v1/merchants/search#show"
  get "/api/v1/merchants",           to: "api/v1/merchants#index"
  post "/api/v1/merchants",          to: "api/v1/merchants#create" 
  patch "/api/v1/merchants/:id",     to: "api/v1/merchants#update"
  delete "/api/v1/merchants/:id",    to: "api/v1/merchants#destroy"
  get "/api/v1/merchants/:id/items", to: "api/v1/merchants/items#index"
  get "/api/v1/merchants/:id",       to: "api/v1/merchants#show"

  get "/api/v1/items/:id/merchant",      to: "api/v1/items#find_merchant"
  get "/api/v1/items/find_all",          to: "api/v1/items/search#show"
  get "/api/v1/items",                   to: "api/v1/items#index"
  get "/api/v1/items/:id",               to: "api/v1/items#show"
  post "/api/v1/items",                  to: "api/v1/items#create"
  put "/api/v1/items/:id",               to: "api/v1/items#update"
  delete "/api/v1/items/:id",            to: "api/v1/items#destroy"

  get "/api/v1/merchants/:merchant_id/invoices", to: "api/v1/invoices#index"

  post '/invoices/:id/add_coupon', to: 'invoices#add_coupon'

  get "/api/v1/merchants/:merchant_id/customers", to: "api/v1/merchants/customers#customers_by_merchant"

  namespace :api do
    namespace :v1 do
      resources :merchants do
        resources :coupons, only: [:index], module: :merchants
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :coupons, only: [:show], module: :coupons
    end
  end
end