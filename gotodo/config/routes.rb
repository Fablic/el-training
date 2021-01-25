Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'tasks#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users, :tasks
  namespace :admin do
    get '/users', to: 'users#index'
    get '/users/:id/tasks', to: 'tasks#index'
  end
  get '/profile', to: 'users#show'
end
