# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  root 'users#new'
  get '/users', to: 'users#new'

  resources :companies, only: %i[index new create destroy]
  resources :food_stores
  resources :food_categories, only: %i[index new create destroy]

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
    get 'search', on: :collection
  end

  get '/order_history', to: 'orders#order_history', as: :order_history
  get '/order_status', to: 'orders#order_status', as: :order_status
  get '/received_orders', to: 'orders#received_orders', as: :received_orders
  post '/notifications/notify', to: 'notifications#notify', as: :notify_notification
  get '/confirm_order', to: 'orders#confirm_order', as: 'confirm_order'

  resources :orders, only: [:show] do
    member do
      patch :approved
      patch :preparing
      patch :finished
      patch :delivered
    end
  end

  get '/order_details', to: 'orders#order_details'

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

  resources :users, only: %i[new create edit update]

  get '/users/:user_id/complete_registration', to: 'users#complete_registration', as: 'complete_registration_user'
  post '/users/:user_id/save_registration', to: 'users#save_registration', as: 'save_registration_user'

  get '/users/:user_id/save_registration', to: 'users#redirect_to_complete_registration',
                                           as: 'save_registration_to_complete'

  get '/users/:user_id', to: 'users#redirect_to_dashboard', as: 'user_dashboard_redirect'

  get 'admin_dashboard', to: 'admin_dashboard#index', as: :admin_dashboard
  get '/employee_dashboard', to: 'employee_dashboard#index', as: :employee_dashboard
  get '/chef_dashboard', to: 'chef_dashboard#index', as: :chef_dashboard

  get 'employees/manage_notifications', to: 'employees#manage_notifications', as: :manage_notifications_employee

  resources :employees, only: [:update] do
    member do
      patch 'update_notifications'
    end
  end

  get 'gallery', to: 'gallery#index'

  patch '/orders/:id/update_status', to: 'orders#update_status', as: 'update_order_status'

  patch 'mark_notification_read/:id', to: 'notifications#mark_as_read', as: :mark_notification_read

  post 'mark_all_notifications_read', to: 'notifications#mark_all_as_read', as: :mark_all_notifications_read

  get '/auth/:provider/callback', to: 'sessions#omniauth'
  get '/auth/facebook/callback', to: 'sessions#omniauth'

  match '*unmatched', to: 'application#not_found_method', via: :all, constraints: lambda { |req|
    !req.path.match(%r{\A/rails/active_storage/})
  }
end

# rubocop:enable Metrics/BlockLength
