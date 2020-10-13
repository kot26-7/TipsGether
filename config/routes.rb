Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :users, except: [:new, :create] do
    post 'guest_login', on: :collection
  end
  resources :posts
end
