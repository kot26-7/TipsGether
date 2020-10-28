Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  get '/search', to: 'home#search'
  resources :users, except: [:new, :create] do
    post 'guest_login', on: :collection
  end
  resources :posts do
    resources :favorites, only: [:create, :destroy]
    resources :comments, only: [:create]
  end
end
