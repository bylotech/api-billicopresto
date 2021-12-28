# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :retailers do
    get "/statistics", to: "retailers#statistics"

    namespace :statistics do
      get "users_by_gender", to: "statistics#users_by_gender"
      get "sales_by_users_value", to: "statistics#sales_by_users_value"
      get "sales_by_products_value", to: "statistics#sales_by_products_value"
      get "daily_product_sales/:id", to: "statistics#daily_product_sales"
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # LANDING-PAGE
  get "welcome", to: "pages#home", as: "welcome"

  # ROOTS

  # get 'dashboard', to: 'pages#dashboard', as: :user_root
  # get 'index', to: 'vouchers#index', as: :retailer_root

  ########

  # To add in Root Controller :

  # if current_user.operator?
  #   render :operator_root
  # elsif current_user.writer?
  #   render :writer_root
  # else current_user.builder?
  #   render :builder_root
  # end

  scope module: 'vouchers' do
    get 'vouchers/filter', to: 'vouchers#filter', as: 'vouchers_filter'
    resources :vouchers, only: [:index, :show, :new, :create]
  end

  namespace :retailers do
    get "/statistics", to: "retailers#statistics"
  end
  # root "articles#index"

  root to: "pages#dashboard"

  # GLOBAL
  devise_for :retailers,
             path: "/retailer",
             path_names: {sign_in: "login", sign_up: "signup", edit: "profile"},
             controllers: {
               sessions: "retailers/sessions",
             }
  devise_for :users,
             path: "/user",
             path_names: {sign_in: "login", sign_up: "signup", edit: "profile"},
             controllers: {
               sessions: "users/sessions",
             }

  # USER
  get "receipts/index"
  get "receipts/index/filter", to: "receipts#filter"
  get "receipts/:id", to: "receipts#show", as: "receiptshow"
end
