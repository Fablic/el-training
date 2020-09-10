# frozen_string_literal: true

Rails.application.routes.draw do
  # タスク画面
  root 'tasks#index'
  resources :tasks
  # ソート機能
  get 'search' => 'tasks#search'

  # サインアップ/ログイン/ログアウト画面
  get '/signup' => 'users#new'
  post '/signup' => 'users#create'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'

  # 管理者画面
  namespace :admins do
    resources :users do
      scope module: :users do
        resources :tasks
      end  
    end
  end

  # エラー画面
  get '*anything' => 'errors#routing_error'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
