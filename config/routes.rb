Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :jokes, only: [:create, :show, :destroy] do
    resources :ai_jokes, only: [:show]
  end

  resources :users, only: [] do
    resources :jokes, only: [:index], controller: 'user_jokes'
  end
end
