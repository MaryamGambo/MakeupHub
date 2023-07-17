Rails.application.routes.draw do
  # get 'products/index'
  # get 'products/show'
  resources :products, only: [:index, :show]

  get 'products/type/:id', to: 'products#type', as: 'products_type'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   root "products#index"
end
