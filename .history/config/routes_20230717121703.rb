Rails.application.routes.draw do
  # get 'products/index'
  # get 'products/show'

  resources :types do
    resources :products, only: :index
  end

  resources :brands do
    resources :products, only: :index
  end

  resources :categories do
    resources :products, only: :index
  end


  resources :products, only: [:index, :show] do
    collection do
      get 'filter'
      get "search"
    end
  end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   root "products#index"
end
