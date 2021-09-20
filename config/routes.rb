Rails.application.routes.draw do
  resources :vouchers, only: [:index, :show, :create, :filter]
  # root "articles#index"
  root to: 'pages#dashboard'
  get 'receipts/index'
  get 'receipts/index/filter', to: 'receipts#filter'
  get 'receipts/:id', to: 'receipts#show', as: 'receiptshow'
  devise_for :retailers
  devise_for :users,
              path: '',
              path_names: {sign_in: 'login', sign_up: 'signup', edit: 'profile'}
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end