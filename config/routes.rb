# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  root 'users#new'
  get '/users', to: 'users#new'

  resources :companies, only: %i[index new create destroy]
  resources :food_stores
  resources :food_categories, only: %i[index new create destroy]

  resources :employees, only: [] do
    patch 'approved', on: :member
    patch 'reject', on: :member
    get 'dashboard', on: :collection
    get 'select', on: :collection
    get 'company_employees', on: :collection, as: 'company'
    get 'ordinary_employees', on: :collection, as: 'ordinary'
    get 'manage_notifications', on: :collection
    patch 'update_notifications', on: :member
  end

  resources :chefs, only: [:index] do
    patch 'approve', on: :member
    patch 'reject', on: :member
    get 'dashboard', on: :collection
  end

  resources :photos, only: %i[index new create destroy] do
    get 'gallery', on: :collection
  end

  resources :food_menus

  resources :orders, only: [:index] do
    post 'place_order', on: :collection
    get 'search', on: :collection
  end

  resources :orders, only: [:show] do
    member do
      patch :approved
      patch :preparing
      patch :finished
      patch :delivered
    end
    get 'order_history', on: :collection
    get 'order_status', on: :collection
    get 'received_orders', on: :collection
    get 'confirm_order', on: :collection
  end

  resources :channels, only: %i[show create] do
    get 'select_users', on: :collection
    post 'send_message', on: :member
    resources :messages, only: [:create]
    get 'messages', on: :member
  end

  resources :sessions, only: %i[new create destroy]

  resources :users, only: %i[new create edit update] do
    get 'complete_registration', on: :member
    post 'save_registration', as: :save_registration, on: :member
    get 'save_registration', on: :member, to: 'users#redirect_to_complete_registration',
                             as: 'save_registration_to_complete'
  end

  resources :admin_dashboard, only: [:index]

  get '/order_details', to: 'orders#order_details'

  post 'mark_all_notifications_read', to: 'application#mark_all_as_read', as: :mark_all_notifications_read

  get '/auth/:provider/callback', to: 'sessions#omniauth'
  get '/auth/facebook/callback', to: 'sessions#omniauth'

  match '*unmatched', to: 'application#not_found_method', via: :all, constraints: lambda { |req|
    !req.path.match(%r{\A/rails/active_storage/})
  }
end

# rubocop:enable Metrics/BlockLength
