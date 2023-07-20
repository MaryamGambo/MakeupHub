Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # get 'carts/show'
  # get 'carts/update'
  # get 'carts/remove'
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

  resources :tags do
  resources :products, only: [:index, :show]
end


  resources :products, only: [:index, :show] do
    collection do
      get 'filter'
      get 'filter_by_category'
      get "search"
    end

    member do
      post 'add_to_cart'
    end
  end

  get '/about', to: 'about#index', as: 'about'
  get '/contact', to: 'contact#index', as: 'contact'
  get 'cart', to: 'carts#show'
  put 'cart/update', to: 'carts#update'
  delete 'cart/remove', to: 'carts#remove'
  resources :pages, only: [:show], param: :slug

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   root "products#index"
end
