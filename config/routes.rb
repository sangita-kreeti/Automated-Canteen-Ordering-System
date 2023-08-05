# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  root 'users#new'
  get '/users', to: 'users#new'

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
  get 'admin_dashboard', to: 'admin_dashboard#index', as: :admin_dashboard
  get '/employee_dashboard', to: 'employee_dashboard#index', as: 'employee_dashboard_index'
  get '/chef_dashboard', to: 'chef_dashboard#index', as: 'chef_dashboard_index'

  get 'gallery', to: 'gallery#index'

  get '/orders/search', to: 'orders#search', as: 'search_orders'

  patch '/orders/:id/update_status', to: 'orders#update_status', as: 'update_order_status'

  get '/register', to: 'users#new'

  patch 'mark_notification_read/:id', to: 'notifications#mark_as_read', as: :mark_notification_read

  post 'mark_all_notifications_read', to: 'notifications#mark_all_as_read', as: :mark_all_notifications_read

  get '/auth/:provider/callback', to: 'sessions#omniauth'
  get '/auth/facebook/callback', to: 'sessions#omniauth'

  resources :users, only: %i[new create edit update]
end

# rubocop:enable Metrics/BlockLength
