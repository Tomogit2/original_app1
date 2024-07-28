Rails.application.routes.draw do
  devise_for :users
  resources :jokes, only: [:create, :show]
  root to: 'home#index'
  
end
