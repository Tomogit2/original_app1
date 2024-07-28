Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  root 'home#index'

  post '/generate_joke', to: 'jokes#create'
  
  resources :jokes, only: [:new, :create, :show]

end
