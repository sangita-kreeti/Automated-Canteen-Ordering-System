# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  root 'users#new'
  get '/users', to: 'users#new'

  resources :companies, only: %i[index new create destroy]
  resources :food_stores
  resources :food_categories, only: %i[index new create destroy]

  resources :employees, only: [] do
    member do
      patch 'approved'
      patch 'reject'
      patch 'update_notifications'
    end

    collection do
      get 'dashboard'
      get 'select'
      get 'all_employees'
      get 'manage_notifications'
    end
  end

  resources :chefs, only: [:index] do
    member do
      patch 'approve'
      patch 'reject'
    end

    collection do
      get 'dashboard'
    end
  end

  resources :photos, only: %i[index new create destroy] do
    collection do
      get 'gallery'
    end
  end

  resources :food_menus

  resources :orders, only: [] do
    collection do
      post 'place_order'
      get 'menus_list'
      get 'search'
      get 'order_history'
      get 'order_status'
      get 'received_orders'
      get 'confirm_order'
    end

    member do
      patch :change_status
    end
  end

  resources :channels, only: %i[show create] do
    collection do
      get 'select_users'
    end

    member do
      post 'send_message'
      get 'messages'

      resources :messages, only: [:create]
    end
  end

  resources :sessions, only: %i[new create destroy]

  resources :users, only: %i[new create edit update] do
    member do
      get 'complete_registration'
      post 'save_registration', as: :save_registration
      get 'save_registration', to: 'users#redirect_to_complete_registration', as: 'save_registration_to_complete'
    end
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
