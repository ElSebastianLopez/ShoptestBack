Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  resources :products
  resources :clients
  resources :transactions


  # Defines the root path route ("/")
  # root "posts#index"
  get 'transactions/by_client/:client_id', to: 'transactions#index_by_client', as: 'transactions_by_client'
  get 'transactions/by_transaction/:transaction_id', to: 'transactions#index_by_transaction', as: 'transaction_details_by_transaction'
  get 'transactions/open_by_client/:client_id', to: 'transactions#index_open_by_client', as: 'transactions_open_by_client'
  post 'transactions/create_transaction_detail', to: 'transactions#create_transaction_detail'

  get 'wompi/merchant_details', to: 'wompi#get_merchant_details'

end
