Rails.application.routes.draw do
  get 'vouchers/filter', to: 'vouchers#filter', as: 'vouchers_filter'
  resources :vouchers, only: [:index, :show, :create]
  # root "articles#index"
  root to: 'pages#dashboard'
  get 'receipts/index'
  get 'receipts/index/filter', to: 'receipts#filter'
  get 'receipts/:id', to: 'receipts#show', as: 'receiptshow'
  devise_for :retailers,
              path: '/retailer',
              path_names: {sign_in: 'login', sign_up: 'signup', edit: 'profile'},
              controllers: {
                sessions: 'retailers/sessions'
              }
  devise_for :users,
              path: '/user',
              path_names: {sign_in: 'login', sign_up: 'signup', edit: 'profile'},
              controllers: {
                sessions: 'users/sessions'
              }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # LANDING-PAGE
  get 'welcome' , to: 'pages#home', as: 'welcome'

end