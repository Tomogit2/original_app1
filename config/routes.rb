Rails.application.routes.draw do
  devise_for :users

  resources :jokes, only: [:create, :show, :destroy]
  resources :ai_jokes, only: [:show]
  resources :users, only: [] do
    resources :jokes, only: [:index], controller: 'user_jokes'
  end
  root to: 'home#index'
end
