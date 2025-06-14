# frozen_string_literal: true

Rails.application.routes.draw do
  get 'up', to: 'rails/health#show', as: :rails_health_check
  root 'static_pages#home'

  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    member do
      get :following
      get :followers
    end
  end

  resources :account_activations, only: %i[edit]
  resources :password_resets, only: %i[new create edit update]
  resources :microposts, only: %i[create destroy]
  get '/microposts', to: 'static_pages#home'
  resources :relationships, only: %i[create destroy]
end
