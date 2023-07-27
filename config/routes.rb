# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  root 'users#new'

  resources :admin_dashboard, only: [:index]
  resources :companies, only: %i[index show new create edit update destroy]
  resources :food_stores
  resources :food_categories, only: %i[index show new create edit update destroy]

  resources :employees, only: [:index] do
    patch 'approved', on: :member
    patch 'reject', on: :member
  end

  resources :chefs, only: [:index] do
    patch 'approve', on: :member
    patch 'reject', on: :member
  end

  resources :photos, only: %i[index new create destroy]
  resources :food_menus

  resources :orders, only: [:index] do
    post 'place_order', on: :collection
  end

  get '/order_history', to: 'orders#order_history', as: :order_history
  get '/order_status', to: 'orders#order_status', as: :order_status

  post '/notifications/notify', to: 'notifications#notify', as: :notify_notification
  get '/confirm_order', to: 'orders#confirm_order', as: 'confirm_order'

  resources :channels, only: %i[show create] do
    get 'select_users', on: :collection
    post 'send_message', on: :member
    resources :messages, only: [:create]
    get 'messages', on: :member
  end

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  post '/logout', to: 'sessions#destroy'
  get '/edit', to: 'users#edit'
  get '/employee_dashboard', to: 'employee_dashboard#index', as: 'employee_dashboard_index'
  get '/chef_dashboard', to: 'chef_dashboard#index', as: 'chef_dashboard_index'

  get 'gallery', to: 'gallery#index'

  get '/orders/search', to: 'orders#search', as: 'search_orders'

  patch '/orders/:id/update_status', to: 'orders#update_status', as: 'update_order_status'

  get '/register', to: 'users#new'

  get '/auth/:provider/callback', to: 'sessions#omniauth'
  get '/auth/facebook/callback', to: 'sessions#omniauth'

  resources :users, only: %i[new create edit update]
end

# rubocop:enable Metrics/BlockLength
