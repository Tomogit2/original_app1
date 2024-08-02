Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :users, only: [] do
    resources :jokes, only: [:index, :show, :destroy]
  end

  resources :jokes, only: [:create, :show, :destroy, :index] do
    resources :ai_jokes, only: [:show]
  end
end
