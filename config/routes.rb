# config/routes.rb
Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :users, only: [] do
    resources :jokes, only: [:index]
  end
  resources :jokes, only: [:index, :show]
  resources :jokes, only: [:index, :create, :destroy]
end
